module Admin

  module ListHelper

    def resources_actions
      @resources_actions ||= []
    end

    def list_actions
      resources_actions.map do |body, url, options|
        if admin_user.can?(url[:action], @resource.name)
          path = params.dup.merge!(url)
          link_to Typus::I18n.t(body), path.cleanup, options # .merge(:target => "_parent")
        end
      end.compact.join(" / ").html_safe
    end

  end

end
