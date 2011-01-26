module Typus

  module Actions

    protected

    def add_resource_action(*args)
      @resource_actions ||= []
      @resource_actions << args
    end

    def prepend_resource_action(*args)
      @resource_actions ||= []
      @resource_actions = @resource_actions.unshift(args)
    end

    def append_resource_action(*args)
      @resource_actions ||= []
      @resource_actions = @resource_actions.concat([args])
    end

    # FIXME: I know this is ugly but first of all I want to see it working.

    def add_resources_action(*args)
      @resources_actions ||= []
      @resources_actions << args
    end

    def prepend_resources_action(*args)
      @resources_actions ||= []
      @resources_actions = @resources_actions.unshift(args)
    end

    def append_resources_action(*args)
      @resources_actions ||= []
      @resources_actions = @resources_actions.concat([args])
    end

  end

end
