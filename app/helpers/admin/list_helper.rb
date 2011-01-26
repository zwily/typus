module Admin

  module ListHelper

    def resources_actions
      @resources_actions ||= []
    end

    def list_actions
      resources_actions.map do |body, url, options|
        if admin_user.can?(url[:action], @resource.name)

          this_url = params.merge(url)
          whitelist = %w(layout CKEditor CKEditorFuncNum langCode)
          this_url.delete_if { |k, v| !whitelist.include?(k) }

          this_options = options.merge(:target => "_parent")
          link_to Typus::I18n.t(body), this_url, this_options
        end
      end.compact.join(" / ").html_safe
    end

  end

end
