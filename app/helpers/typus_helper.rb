module TypusHelper

  def typus_block(*args)

    options = args.extract_options!

    partials_path = "admin/#{options[:location]}"
    resources_partials_path = 'admin/resources'

    partials = ActionController::Base.view_paths.map do |view_path|
      Dir["#{view_path.path}/#{partials_path}/*"].map { |f| File.basename(f, '.html.erb') }
    end.flatten
    resources_partials = Dir["#{Rails.root}/app/views/#{resources_partials_path}/*"].map { |f| File.basename(f, '.html.erb') }

    partial = "_#{options[:partial]}"

    path = if partials.include?(partial) then partials_path
           elsif resources_partials.include?(partial) then resources_partials_path
           end

    render "#{path}/#{options[:partial]}" if path

  end

  def page_title(action = params[:action])
    crumbs = []
    crumbs << @resource[:human_name].pluralize if @resource
    crumbs << _(action.humanize) unless %w( index ).include?(action)
    return "#{Typus::Configuration.options[:app_name]} - " + crumbs.compact.map { |x| x }.join(' &rsaquo; ')
  end

  def header

    links = [ (link_to_unless_current _("Dashboard"), admin_dashboard_path) ]

    Typus.models_on_header.each do |model|
      links << (link_to_unless_current model.constantize.typus_human_name.pluralize, :controller => "/admin/#{model.tableize}")
    end

    if ActionController::Routing::Routes.named_routes.routes.has_key?(:root)
      links << (link_to _("View site"), root_path, :target => 'blank')
    end

    render "admin/helpers/header", :links => links

  end

  def login_info(user = @current_user)

    admin_edit_typus_user_path = { :controller => "/admin/#{Typus::Configuration.options[:user_class_name].tableize}", 
                                   :action => 'edit', 
                                   :id => user.id }

    message = _("Are you sure you want to sign out and end your session?")

    user_details = if user.can?('edit', Typus::Configuration.options[:user_class_name])
                     link_to user.name, admin_edit_typus_user_path, :title => "#{user.email} (#{user.role})"
                   else
                     user.name
                   end

    render "admin/helpers/login_info", :message => message, :user_details => user_details

  end

  def display_flash_message(message = flash)
    return if message.empty?
    flash_type = message.keys.first
    render "admin/helpers/flash_message", :flash_type => flash_type, :message => message
  end

end