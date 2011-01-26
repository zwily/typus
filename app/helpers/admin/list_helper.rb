module Admin

  module ListHelper

    def resources_actions
      @resources_actions ||= []
    end

    def list_actions
      resources_actions.map do |action|
        if admin_user.can?(action[:action], @resource.name)
          link_to Typus::I18n.t(action[:action_name]),
                  { :controller => @resource.to_resource, :action => action[:action], :resource => action[:resource], :resource_id => action[:resource_id], :layout => params[:layout] },
                  { :confirm => action[:confirm], :method => action[:method], :target => "_parent" }
        end
      end.compact.join(" / ").html_safe
    end

  end

end
