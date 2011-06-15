module Typus
  module Controller
    module Filters

      def self.included(base)
        base.helper_method :predefined_filters
      end

      protected

      def add_predefined_filter(*args)
        predefined_filters
        @predefined_filters << args unless args.empty?
      end

      def prepend_predefined_filter(*args)
        predefined_filters
        @predefined_filters = @predefined_filters.unshift(args) unless args.empty?
      end

      def append_predefined_filter(*args)
        predefined_filters
        @predefined_filters = @predefined_filters.concat([args]) unless args.empty?
      end

      def predefined_filters
        @predefined_filters ||= []
      end

    end
  end
end
