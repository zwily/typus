module Admin::Resources::DataTypes::BelongsToHelper

  def typus_belongs_to_field(attribute, form)
    association = @resource.reflect_on_association(attribute.to_sym)

    related = if defined?(set_belongs_to_context)
                set_belongs_to_context.send(attribute.pluralize.to_sym)
              else
                association.class_name.typus_constantize
              end
    related_fk = association.foreign_key

    # TODO: Use the build_add_new method.
    if admin_user.can?('create', related)
      options = { :controller => "/admin/#{related.to_resource}",
                  :action => 'new',
                  :resource => @resource.model_name,
                  :layout => 'admin/headless' }
      # Pass the resource_id only to edit/update because only there is where
      # the record actually exists.
      options.merge!(:resource_id => @item.id) if %w(edit update).include?(params[:action])
      message = link_to Typus::I18n.t("Add New"), options, { :class => 'iframe' }
    end

    # By default the used template is ALWAYS `belongs_to` unless we have the
    # `Typus.autocomplete` feature enabled.
    template = Typus.autocomplete ? "belongs_to_with_autocomplete" : "belongs_to"

    # If `Typus.autocomplete` is enabled we don't set the values as will be
    # autocompleted.
    if related.respond_to?(:roots)
      values = expand_tree_into_select_field(related.roots, related_fk)
    elsif !Typus.autocomplete
      values = related.order(related.typus_order_by).map { |p| [p.to_label, p.id] }
    end

    render "admin/templates/#{template}",
           :association => association,
           :resource => @resource,
           :attribute => attribute,
           :form => form,
           :related_fk => related_fk,
           :related => related,
           :message => message,
           :label_text => @resource.human_attribute_name(attribute),
           :values => values,
           :html_options => { :disabled => attribute_disabled?(attribute) },
           :options => { :include_blank => true }
  end

  def table_belongs_to_field(attribute, item)
    if att_value = item.send(attribute)
      action = item.send(attribute).class.typus_options_for(:default_action_on_item)
      message = att_value.to_label
      if admin_user.can?(action, att_value.class.name)
        message = link_to(message, :controller => "/admin/#{att_value.class.to_resource}", :action => action, :id => att_value.id)
      end
    end

    message || "&mdash;".html_safe
  end

  def display_belongs_to(item, attribute)
    data = item.send(attribute)
    link_to data.to_label, { :controller => data.class.to_resource,
                             :action => data.class.typus_options_for(:default_action_on_item),
                             :id => data.id }
  end

  def belongs_to_filter(filter)
    att_assoc = @resource.reflect_on_association(filter.to_sym)
    class_name = att_assoc.options[:class_name] || filter.capitalize.camelize
    resource = class_name.typus_constantize

    items = [[Typus::I18n.t("View all %{attribute}", :attribute => @resource.human_attribute_name(filter).downcase.pluralize), ""]]
    items += resource.order(resource.typus_order_by).map { |v| [v.to_label, v.id] }
  end

end
