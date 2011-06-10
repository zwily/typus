module Admin
  module SidebarHelper

    def build_sidebar
      resources = ActiveSupport::OrderedHash.new
      app_name = @resource.typus_application

      admin_user.application(app_name).sort {|a,b| a.typus_constantize.model_name.human <=> b.typus_constantize.model_name.human}.each do |resource|
        klass = resource.typus_constantize

        resources[resource] = default_actions(klass)
        resources[resource] += custom_actions(klass)

        resources[resource].compact!
      end

      render "admin/helpers/sidebar/sidebar", :resources => resources
    end

    def default_actions(klass)
      Array.new.tap do |tap|
        tap << link_to_unless_current(Typus::I18n.t("All #{klass.model_name.human.pluralize}"), :action => "index")
        tap << link_to_unless_current(Typus::I18n.t("Add New"), :action => "new") if admin_user.can?("create", klass)
      end
    end

    def custom_actions(klass)
      klass.typus_actions_on(params[:action]).map do |action|
        if admin_user.can?(action, klass)
          link_to_unless_current(Typus::I18n.t(action.humanize), params.merge(:action => action))
        end
      end
    end

 end
end
