module Typus
  module Controller
    module Headless

      def self.included(base)
        base.before_filter :set_resources_action_for_headless_on_index, :only => [:index]
        base.before_filter :set_resources_action_for_headless, :only => [:new, :create, :edit, :show]
        base.layout :set_headless_layout
      end

      def set_resources_action_for_headless_on_index
        add_resources_action("Add New", {:action => "new"}, {})
      end
      private :set_resources_action_for_headless_on_index

      def set_resources_action_for_headless
        add_resources_action("All Entries", {:action => 'index', :id => nil}, {})
      end
      private :set_resources_action_for_headless

      def set_headless_layout
        params[:layout] || "admin/base"
      end
      private :set_headless_layout

      def headless_mode_with_custom_action_is_enabled?
        params[:layout] == "admin/headless" && params[:resource_action]
      end
      private :headless_mode_with_custom_action_is_enabled?

      def set_headless_resource_actions
        body = params[:resource_action].titleize
        url = { :controller => params[:resource].tableize,
                :action => params[:resource_action],
                :resource => params[:resource],
                :resource_id => params[:resource_id],
                :return_to => params[:return_to] }
        options = { :target => "_parent" }
        add_resource_action(body, url, options)
      end

    end
  end
end
