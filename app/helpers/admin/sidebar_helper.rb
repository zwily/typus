module Admin
  module SidebarHelper

    def build_sidebar
      resources = ActiveSupport::OrderedHash.new
      app_name = @resource.typus_application

      admin_user.application(app_name).sort { |a,b| a.typus_constantize.model_name.human <=> b.typus_constantize.model_name.human }.each do |resource|
        klass = resource.typus_constantize
        resources[resource] = [ link_to_unless_current(Typus::I18n.t("All #{klass.model_name.human.pluralize}"), :action => "index") ]
        resources[resource] << link_to_unless_current(Typus::I18n.t("Add New"), :action => "new") if admin_user.can?("create", klass)
      end

      render "admin/helpers/sidebar/sidebar", :resources => resources
    end

  end
end
