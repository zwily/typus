module Typus
  module Controller
    module Filters

      protected

      def add_predefined_filter(*args)
        @predefined_filters ||= []
        @predefined_filters << args unless args.empty?
      end

    end
  end
end
