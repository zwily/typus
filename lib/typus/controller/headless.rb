module Typus
  module Controller
    module Headless

      def self.included(base)
        base.helper_method :headless_mode?
        base.layout :headless_layout
      end

      def headless_layout
        headless_mode? ? "admin/headless" : "admin/base"
      end
      private :headless_layout

      def headless_mode?
        params[:_popup]
      end

    end
  end
end
