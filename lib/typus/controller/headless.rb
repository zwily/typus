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
        add_resources_action("Back to list", {:action => 'index', :id => nil}, {})
      end
      private :set_resources_action_for_headless

      def set_headless_layout
        params[:layout] || "admin/base"
      end
      private :set_headless_layout

    end
  end
end
