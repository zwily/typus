module Admin

  module ResourcesHelper

    include FiltersHelper
    include FormHelper
    include SearchHelper
    include SidebarHelper
    include TableHelper

    def display_link_to_previous
      return unless params[:back_to]

      options = {}
      options[:resource_from] = @resource[:human_name]
      options[:resource_to] = params[:resource].classify.constantize.human_name if params[:resource]

      editing = %w( edit update ).include?(params[:action])
      message = case
                when params[:resource] && editing
                  "You're updating a {{resource_from}} for {{resource_to}}."
                when editing
                  "You're updating a {{resource_from}}."
                when params[:resource]
                  "You're adding a new {{resource_from}} to {{resource_to}}."
                else
                  "You're adding a new {{resource_from}}."
                end
      message = _(message, 
                  :resource_from => options[:resource_from], 
                  :resource_to => options[:resource_to])

      render "admin/helpers/display_link_to_previous", :message => message
    end

    def remove_filter_link(filter = request.env['QUERY_STRING'])
      return unless filter && !filter.blank?
      link_to _("Remove filter")
    end

    ##
    # If there's a partial with a "microformat" of the data we want to 
    # display, this will be used, otherwise we use a default table which 
    # it's build from the options defined on the yaml configuration file.
    #
    def build_list(model, fields, items, resource = @resource[:self], link_options = {}, association = nil)
      template = "app/views/admin/#{resource}/_#{resource.singularize}.html.erb"

      if File.exist?(template)
        render :partial => template.gsub('/_', '/'), :collection => items, :as => :item
      else
        build_typus_table(model, fields, items, link_options, association)
      end
    end

    def pagination(*args)
      @options = args.extract_options!
      render "admin/helpers/pagination" if @items.prev || @items.next
    end

    def link_to_edit(klass = @resource[:class])
      condition = if klass.typus_user_id? && @current_user.is_not_root?
                    @item.owned_by?(@current_user)
                  else
                    @current_user.can?('update', klass)
                  end
      link_to_if condition, _("Edit"), :action => "edit", :id => @item.id
    end

    def link_to_show
      link_to _("Show"), :action => 'show', :id => @item.id
    end

=begin

    # This method should show a list of actions for the actual record.
    def custom_actions(klass)
      options = { :controller => klass.to_resource }
      items = klass.typus_actions_on("index").map do |action|
        if @current_user.can?(action, klass)
          (link_to _(action.humanize), options.merge(:action => action).to_hash.symbolize_keys)
        end
      end
    end

=end

  end

end
