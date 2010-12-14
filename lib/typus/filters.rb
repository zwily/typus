module Typus

  module Filters

    class ActionController::Base

      protected

      def add_predefined_filter(filter, action, scope)
        @predefined_filters ||= [["All", "index", "unscoped"]]
        @predefined_filters << [filter, action, scope]
      end

      def self.add_predefined_filter(filter, action, scope)
        before_filter options do |controller|
          controller.send(:add_predefined_filter, filter, action, scope)
        end
      end

    end

    module Helper

      def predefined_filters
        @predefined_filters ||= [["All", "index", "unscoped"]]
      end

    end

  end

end

ActionController::Base.send(:include, Typus::Filters)
ActionView::Base.send(:include, Typus::Filters::Helper)
