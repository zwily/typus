module Admin

  module SidebarHelper

    def build_sidebar
      resources = ActiveSupport::OrderedHash.new
      app_name = @resource[:class].typus_defaults_for("application").to_s

      Typus.application(app_name).each do |resource|
        resources[resource] = actions + export
      end

      render "admin/helpers/sidebar", :resources => resources
    end

    # TODO: Test "Show " case.
    def actions

      items = []

      case params[:action]
      when "new", "index", "edit", "show", "update"
        if @current_user.can?('create', @resource[:class])
          message = _("Add New")
          items << (link_to message, { :action => 'new' }, :class => 'new')
        end
      end

      case params[:action]
      when 'edit'
        message = _("Show")
        items << (link_to message, :action => 'show', :id => @item.id)
      end

      case params[:action]
      when 'show'
        condition = if @resource[:class].typus_user_id? && @current_user.is_not_root?
                      @item.owned_by?(@current_user)
                    else
                      @current_user.can?('update', @resource[:class])
                    end
        message = _("Edit")
        items << (link_to_if condition, message, :action => 'edit', :id => @item.id)
      end

      @resource[:class].typus_actions_on(params[:action]).each do |action|
        if @current_user.can?(action, @resource[:class])
          items << (link_to _(action.humanize), params.merge(:action => action).to_hash.symbolize_keys)
        end
      end

      return items

    end

    def export
      return [] unless params[:action] == "index"
      @resource[:class].typus_export_formats.map do |format|
        link_to _("Export as {{format}}", :format => format.upcase), params.merge(:format => format).to_hash.symbolize_keys
      end
    end

    def previous_and_next(klass = @resource[:class])

      items = []

      if @next
        action = if klass.typus_user_id? && @current_user.is_not_root?
                   @next.owned_by?(@current_user) ? 'edit' : 'show'
                 else
                   @current_user.cannot?('edit', klass) ? 'show' : params[:action]
                 end
        items << (link_to _("Next"), params.merge(:action => action, :id => @next.id).to_hash.symbolize_keys)
      end

      if @previous
        action = if klass.typus_user_id? && @current_user.is_not_root?
                   @previous.owned_by?(@current_user) ? 'edit' : 'show'
                 else
                   @current_user.cannot?('edit', klass) ? 'show' : params[:action]
                 end
        items << (link_to _("Previous"), params.merge(:action => action, :id => @previous.id).to_hash.symbolize_keys)
      end

      return items

    end

 end

end
