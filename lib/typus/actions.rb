module Typus

  module Actions

    class ActionController::Base

      protected

      def add_action(*args)
        options = args.extract_options!
        @actions ||= []
        @actions << options
      end

      def prepend_action(*args)
        options = args.extract_options!
        @actions ||= []
        @actions = @actions.unshift(options)
      end

      def append_action(*args)
        options = args.extract_options!
        @actions ||= []
        @actions = @actions.concat([options])
      end

    end

    module Helper

      def actions
        @actions ||= []
      end

    end

  end

end

ActionController::Base.send(:include, Typus::Actions)
ActionView::Base.send(:include, Typus::Actions::Helper)
