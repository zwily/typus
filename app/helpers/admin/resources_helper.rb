module Admin::ResourcesHelper

  def admin_search(resource = @resource, params = params)
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
      klass = resource.constantize
      unless klass.typus_options_for(:hide_from_sidebar)
        resources[resource] = [sidebar_add_new(klass)].compact
      end
    end

    if resources.any?
      render "helpers/admin/resources/sidebar", :resources => resources
    else
      render "admin/dashboard/sidebar"
    end
  end

  def sidebar_add_new(klass)
    if admin_user.can?("create", klass)
      { :message => Typus::I18n.t("Add"), :url => { :action => "new" } }
    end
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
