module Admin::Resources::DataTypes::HasAndBelongsToManyHelper

  def table_has_and_belongs_to_many_field(attribute, item)
    item.send(attribute).map { |i| i.to_label }.join(", ")
  end

  alias :table_has_many_field :table_has_and_belongs_to_many_field

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

end
