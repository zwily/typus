module Admin::Resources::DataTypes::HasAndBelongsToManyHelper

  def table_has_and_belongs_to_many_field(attribute, item)
    item.send(attribute).map { |i| i.to_label }.join(", ")
  end

  alias_method :table_has_many_field, :table_has_and_belongs_to_many_field

  def typus_form_has_and_belongs_to_many(field)
    setup_relationship(field)
    build_pagination

    # TODO: Find a cleaner way to add these actions ...
    @resource_actions = [["Edit", { :action => "edit", :layout => 'admin/headless' }, { :class => 'iframe' }],
                         ["Unrelate", { :resource_id => @item.id,
                                        :resource => @resource.model_name,
                                        :action => "unrelate"},
                                      { :confirm =>"Unrelate?" }]]

    locals = { :association_name => @association_name, :add_new => build_add_new, :table => build_relationship_table }
    render "admin/templates/has_n", locals
  end

  def typus_has_and_belongs_to_many_field(attribute, form)
    label_text = @resource.human_attribute_name(attribute)

    locals = { :attribute => attribute,
               :attribute_id => "#{@resource.table_name}_#{attribute}",
               :related_items => attribute.singularize.capitalize.constantize.all,
               :related_ids => "#{@resource.name.downcase}[#{attribute.singularize}_ids][]",
               :form => form,
               :label_text => label_text.html_safe }

    render "admin/templates/has_and_belongs_to_many", locals
  end

end
