module Admin

  module SidebarHelper

    def build_sidebar
      resources = ActiveSupport::OrderedHash.new
      app_name = @resource.typus_application

      Typus.application(app_name).each do |resource|
        next unless @current_user.resources.include?(resource)
        klass = resource.constantize
        resources[resource] = [ default_actions(klass) ] + export(klass) + custom_actions(klass)
      end

      render "admin/helpers/sidebar/sidebar", :resources => resources
    end

    def default_actions(klass)
      return unless @current_user.can?('create', klass)
      options = { :controller => klass.to_resource }
      message = _("Add New")
      link_to_unless_current message, options.merge(:action => "new"), :class => "new"
    end

    def custom_actions(klass)
      options = { :controller => klass.to_resource }
      items = klass.typus_actions_on("index").map do |action|
        if @current_user.can?(action, klass)
          (link_to _(action.humanize), options.merge(:action => action))
        end
      end
    end

    def export(klass)
      klass.typus_export_formats.map do |format|
        link_to _("Export as {{format}}", :format => format.upcase), params.merge(:action => "index", :format => format)
      end
    end

 end

end
