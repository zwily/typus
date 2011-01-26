module Typus

  module Actions

    protected

    def add_resource_action(*args)
      options = args.extract_options!
      @resource_actions ||= []
      @resource_actions << options
    end

    def prepend_resource_action(*args)
      options = args.extract_options!
      @resource_actions ||= []
      @resource_actions = @resource_actions.unshift(options)
    end

    def append_resource_action(*args)
      options = args.extract_options!
      @resource_actions ||= []
      @resource_actions = @resource_actions.concat([options])
    end

  end

end
