module Admin::Resources::DataTypes::HasAndBelongsToManyHelper

  def table_has_and_belongs_to_many_field(attribute, item)
    item.send(attribute).map { |i| i.to_label }.join(", ")
  end

  alias_method :table_has_many_field, :table_has_and_belongs_to_many_field

  def typus_has_and_belongs_to_many_field(attribute, form)
    klass = attribute.singularize.capitalize.constantize

    label_text = @resource.human_attribute_name(attribute)

=begin
    # TODO: Make it work as we expect.
    if (link = build_add_new_for_has_and_belongs_to_many(klass))
      label_text += " <small>#{link}</small>"
    end
=end

    locals = { :attribute => attribute,
               :attribute_id => "#{@resource.table_name}_#{attribute}",
               :related_klass => klass,
               :related_items => klass.all,
               :related_ids => "#{@resource.name.downcase}[#{attribute.singularize}_ids][]",
               :values => @item.send(attribute),
               :form => form,
               :label_text => label_text.html_safe }

    render "admin/templates/has_and_belongs_to_many", locals
  end

  def build_add_new_for_has_and_belongs_to_many(klass)
    if admin_user.can?("create", klass)
      options = { :controller => "/admin/#{klass.to_resource}",
                  :action => "new",
                  :layout => "admin/headless",
                  :return_to => request.path }

      link_to Typus::I18n.t("Add New"), options, { :class => "iframe" }
    end
  end

end
