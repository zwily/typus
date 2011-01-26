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

    # FIXME: I know this is ugly but first of all I want to see it working.

    def add_resources_action(*args)
      options = args.extract_options!
      @resources_actions ||= []
      @resources_actions << options
    end

    def prepend_resources_action(*args)
      options = args.extract_options!
      @resources_actions ||= []
      @resources_actions = @resources_actions.unshift(options)
    end

    def append_resources_action(*args)
      options = args.extract_options!
      @resources_actions ||= []
      @resources_actions = @resources_actions.concat([options])
    end

  end

end
