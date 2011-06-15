module Admin::ResourcesHelper

  def search(resource = @resource, params = params)
    if (typus_search = resource.typus_defaults_for(:search)) && typus_search.any?

      hidden_filters = params.dup
      rejections = %w(controller action locale utf8 sort_order order_by search page)
      hidden_filters.delete_if { |k, v| rejections.include?(k) }

      render "helpers/admin/resources/search", :hidden_filters => hidden_filters
    end
  end

  def build_sidebar
    resources = ActiveSupport::OrderedHash.new
    app_name = @resource.typus_application

    admin_user.application(app_name).sort { |a,b| a.typus_constantize.model_name.human <=> b.typus_constantize.model_name.human }.each do |resource|
      klass = resource.typus_constantize
      resources[resource] = [ link_to_unless_current(Typus::I18n.t("All #{klass.model_name.human.pluralize}"), :action => "index") ]
      resources[resource] << link_to_unless_current(Typus::I18n.t("Add New"), :action => "new") if admin_user.can?("create", klass)
    end

    render "helpers/admin/resources/sidebar", :resources => resources
  end

  def resource_actions
    @resource_actions ||= []
  end

  def resources_actions
    @resources_actions ||= []
  end

end
