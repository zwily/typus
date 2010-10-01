module Admin

  module SidebarHelper

    def build_sidebar
      resources = ActiveSupport::OrderedHash.new
      app_name = @resource.typus_application

      Typus.application(app_name).sort {|a,b| a.constantize.model_name.human <=> b.constantize.model_name.human}.each do |resource|
        next unless @current_user.resources.include?(resource)
        klass = resource.constantize
        resources[resource] = default_actions(klass) + export(klass) + custom_actions(klass)
        resources[resource].compact!
      end

      render "admin/helpers/sidebar/sidebar", :resources => resources
    end

    def default_actions(klass)
      actions = []
      options = { :controller => klass.to_resource }

      if @current_user.can?("create", klass)
        message = _t("Add new")
        actions << link_to_unless_current(message, options.merge(:action => "new"))
      end

      message = _t("List")
      actions << link_to_unless_current(message, options)

      return actions
    end

    def export(klass)
      return [] unless params[:action] == "index"

      klass.typus_export_formats.map do |format|
        link_to _t("Export as %{format}", :format => format.upcase), params.merge(:format => format)
      end
    end

    def custom_actions(klass)
      options = { :controller => klass.to_resource }
      klass.typus_actions_on(params[:action]).map do |action|
        if @current_user.can?(action, klass)
          (link_to_unless_current _t(action.humanize), options.merge(:action => action))
        end
      end
    end

 end

end
