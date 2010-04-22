module Admin

  module SidebarHelper

    def build_sidebar
      resources = ActiveSupport::OrderedHash.new
      app_name = @resource.typus_defaults_for("application").to_s

      Typus.application(app_name).each do |resource|
        klass = resource.constantize
        resources[resource] = [ default_actions(klass) ] + export(klass) + custom_actions(klass)
      end

      render "admin/helpers/sidebar/sidebar", :resources => resources
    end

    def default_actions(klass)
      return unless @current_user.can?('create', klass)
      options = { :controller => klass.to_resource }
      message = _("Add New")
      link_to_unless_current message, options.merge(:action => "new"), :class => 'new'
    end

    def custom_actions(klass)
      options = { :controller => klass.to_resource }
      items = klass.typus_actions_on("index").map do |action|
        if @current_user.can?(action, klass)
          (link_to _(action.humanize), options.merge(:action => action).to_hash.symbolize_keys)
        end
      end
    end

    def export(klass)
      klass.typus_export_formats.map do |format|
        link_to _("Export as {{format}}", :format => format.upcase), params.merge(:action => "index", :format => format).to_hash.symbolize_keys
      end
    end

 end

end

=begin

    def previous_and_next(klass = @resource)

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

=end