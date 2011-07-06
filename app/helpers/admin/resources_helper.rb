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

    admin_user.application(app_name).each do |resource|
      klass = resource.typus_constantize
      resources[resource] = [sidebar_all_resource(klass), sidebar_add_new(klass)].compact
    end

    render "helpers/admin/resources/sidebar", :resources => resources
  end

  def sidebar_add_new(klass)
    if admin_user.can?("dcreate", klass)
      { :message => Typus::I18n.t("Add New"), :url => { :action => "new" } }
    end
  end

  def sidebar_all_resource(klass)
    { :message => Typus::I18n.t("All #{klass.model_name.human.pluralize}"), :url => { :action => "index" } }
  end

  # TODO: This method should be moved to `lib/typus/controller/actions.rb`
  def resource_actions
    @resource_actions ||= []
  end

  # TODO: This method should be moved to `lib/typus/controller/actions.rb`
  def resources_actions
    @resources_actions ||= []
  end

end
