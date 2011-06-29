module Admin::Resources::RelationshipsHelper

  def setup_relationship(field)
    @field = field
    @model_to_relate = @resource.reflect_on_association(field.to_sym).class_name.typus_constantize
    @model_to_relate_as_resource = @model_to_relate.to_resource
    @reflection = @resource.reflect_on_association(field.to_sym)
    @association_name = @reflection.name.to_s
  end

  def build_pagination
    items_per_page = @model_to_relate.typus_options_for(:per_page)
    data = @item.send(@field).order(@model_to_relate.typus_order_by).where(set_conditions)
    @items = data.page(params[:page]).per(items_per_page)
  end

  def build_relationship_table
    build_list(@model_to_relate,
               @model_to_relate.typus_fields_for(:relationship),
               @items,
               @model_to_relate_as_resource,
               {},
               @reflection.macro,
               @association_name)
  end

  def build_add_new(options = {})
    default_options = { :controller => "/admin/#{@model_to_relate.to_resource}",
                        :action => "index",
                        :resource => @resource.model_name,
                        :layout => 'admin/headless',
                        :resource_id => @item.id,
                        :resource_action => 'relate',
                        :return_to => request.path }

    # Add new basically means: We can create new items or relate existing ones.
    create_or_read = admin_user.can?("create", @model_to_relate) || admin_user.can?("read", @model_to_relate)

    if set_condition && create_or_read
      link_to Typus::I18n.t("Add New"), default_options.merge(options), { :class => "iframe" }
    end
  end

  def set_condition
    (@resource.typus_user_id? && admin_user.is_not_root?) ? admin_user.owns?(@item) : true
  end

  def set_conditions
    if @model_to_relate.typus_options_for(:only_user_items) && admin_user.is_not_root?
      { Typus.user_foreign_key => admin_user }
    end
  end

end
