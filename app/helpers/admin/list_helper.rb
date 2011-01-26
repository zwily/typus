module Admin

  module ListHelper

    def resources_actions
      @resources_actions ||= []
    end

    def list_actions
      resources_actions.map do |body, url, options|
        if admin_user.can?(url[:action], @resource.name)
          link_to Typus::I18n.t(body),
                  url.merge(:layout => params[:layout]),
                  options.merge(:target => "_parent")
        end
      end.compact.join(" / ").html_safe
    end

  end

end
