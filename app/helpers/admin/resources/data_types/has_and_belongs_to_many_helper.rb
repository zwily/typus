module Admin::Resources::DataTypes::HasAndBelongsToManyHelper

  def table_has_and_belongs_to_many_field(attribute, item)
    item.send(attribute).map { |i| i.to_label }.join(", ")
  end

  alias_method :table_has_many_field, :table_has_and_belongs_to_many_field

  def typus_has_and_belongs_to_many_field(attribute, form)
    klass = attribute.singularize.capitalize.constantize
    resource_ids = "#{attribute.singularize}_ids"

    html_options = { :disabled => attribute_disabled?(resource_ids.to_sym) }

    label_text = @resource.human_attribute_name(attribute)
    if (text = build_label_text_for_has_and_belongs_to_many(klass, html_options))
      label_text += "<small>#{text}</small>"
    end

    locals = { :attribute => attribute,
               :attribute_id => "#{@resource.table_name}_#{attribute}",
               :related_klass => klass,
               :related_items => klass.all,
               :related_ids => "#{@resource.name.downcase}[#{resource_ids}][]",
               :values => @item.send(attribute),
               :form => form,
               :label_text => label_text.html_safe,
               :html_options => html_options }

    render "admin/templates/has_and_belongs_to_many", locals
  end

  def build_label_text_for_has_and_belongs_to_many(klass, html_options)
    if html_options[:disabled] == true
      Typus::I18n.t("Read only")
=begin
    # TODO: Take this back at some point in the future. Adding a new item
    #       using the pop-up should update the items on the selector. I know
    #       this might be the most trivial thing in the world, but I don't
    #       know how to do it.
    elsif admin_user.can?('create', klass) && !headless_mode?
      build_add_new_for_has_and_belongs_to_many(klass)
=end
    end
  end

  def build_add_new_for_has_and_belongs_to_many(klass)
    options = { :controller => "/admin/#{klass.to_resource}",
                :action => "new",
                :layout => "admin/headless" }

    link_to Typus::I18n.t("Add New"), options, { :class => "iframe" }
  end

end
