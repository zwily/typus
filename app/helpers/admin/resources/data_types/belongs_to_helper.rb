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

    # Set the template.
    template = if Typus.autocomplete && (related.respond_to?(:roots) || !(related.count > Typus.autocomplete))
                 "admin/templates/belongs_to"
               else
                 "admin/templates/belongs_to_with_autocomplete"
               end

    # Set the values.
    values = if related.respond_to?(:roots)
               expand_tree_into_select_field(related.roots, related_fk)
             elsif Typus.autocomplete && !(related.count > Typus.autocomplete)
               related.order(related.typus_order_by).map { |p| [p.to_label, p.id] }
             end

    render template,
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

end
