module Admin::Resources::DataTypes::HasOneHelper

  def typus_form_has_one(field)
    setup_relationship(field)

    @items = Array.new
    if item = @item.send(field)
      @items << item
    end

    # TODO: Find a cleaner way to add these actions ...
    @resource_actions = [["Edit", {:action=>"edit"}, {}],
                         ["Trash", { :resource_id => @item.id, :resource => @resource.model_name, :action => "destroy" }, { :confirm => "Trash?" }]]

    options = { :resource_id => nil, @reflection.foreign_key => @item.id }

    render "admin/templates/has_one",
           :association_name => @association_name,
           :add_new => @items.empty? ? build_add_new(options) : nil,
           :table => build_relationship_table
  end

end
