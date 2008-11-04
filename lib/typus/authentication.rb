module Authentication

protected

  ##
  # Require require login checks if the user is logged on Typus, 
  # otherwhise is sent to the login page with a :back_to param to 
  # return where she tried to go.
  #
  def require_login
    unless session[:typus]
      back_to = (request.env['REQUEST_URI'] == '/admin') ? nil : request.env['REQUEST_URI']
      redirect_to typus_login_url(:back_to => back_to)
    end
  end

  ##
  # Check if the user is logged on the system.
  #
  def logged_in?
    return false unless session[:typus]
    begin
      @current_user ||= TypusUser.find(session[:typus])
    rescue ActiveRecord::RecordNotFound
      session[:typus] = nil
    end
  end

  ##
  # Return the current user
  #
  def current_user
    @current_user if logged_in?
    unless Typus::Configuration.roles.keys.include? @current_user.roles
      session[:typus] = nil
      flash[:error] = "#{@current_user.roles.capitalize} role doesn't exist on the system."
      redirect_to typus_login_url
    end
  end

  ##
  # Password generation using numbers and letters.
  #
  def generate_password(length = 8)
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    if Typus::Configuration.options[:special_characters_on_password]
      chars += %w( @ # $ % & / ? ! * . , ; : _ - )
    end
    password = ""
    1.upto(length) { |i| password << chars[rand(chars.size - 1)] }
    return password
  end

  ##
  # Before filter to check if has permission to index, edit, update 
  # & destroy a model.
  #
  def check_permissions
    unless @current_user.resources.include? @model.to_s or @current_user.resources.include? "All"
      flash[:notice] = "You don't have permission to access this resource."
      redirect_to :back
    end
  rescue
    redirect_to typus_dashboard_url
  end

  ##
  # Before updating a TypusUser we check we can update his role
  #
  def check_role
    if @model == TypusUser
      unless @current_user.roles.include? Typus::Configuration.options[:root]
        unless @item.roles == params[:item][:roles]
          flash[:error] = "Only %s can change roles." % Typus::Configuration.options[:root]
          redirect_to :back
        end
      end
    end
  end

  ##
  # A TypusUser cannot destroy himself
  #
  def check_ownership
    if @model == TypusUser and @current_user.id == params[:id].to_i
      case params[:action]
      when 'destroy'
        flash[:notice] = "You cannot remove yourself from Typus."
      when 'toggle'
        flash[:notice] = "You cannot toggle your %s." % params[:field]
      end
      redirect_to :back
    end
  end

  ##
  # This method checks if the user can perform the requested action.
  # It works on models, so its available on the admin_controller.
  #
  def can_perform_action?

    case params[:action]
    when 'index', 'show'
      message = "#{@current_user.roles.capitalize} can't display items."
    when 'edit', 'update', 'position', 'toggle', 'relate', 'unrelate'
      if @model.new.kind_of?(TypusUser)
        return if Typus::Configuration.options[:root] == @current_user.roles
        if !(params[:id].to_s == session[:typus].to_s)
          flash[:notice] = "As you're not the admin or the owner of this record you cannot edit this record."
          redirect_to :back rescue redirect_to typus_dashboard_url
        end
      end
    when 'destroy'
      message = "#{@current_user.roles.capitalize} can't delete this item."
    else
      message = "#{@current_user.roles.capitalize} can't perform action. (#{params[:action]})"
    end

    unless @current_user.can_perform?(@model, params[:action])
      flash[:notice] = message || "#{@current_user.roles.capitalize} can't perform action. (#{params[:action]})"
      redirect_to :back rescue redirect_to typus_dashboard_url
    end

  end

  ##
  # This method checks if the user can perform the requested action.
  # It works on resources, which are not models, so its available on 
  # the typus_controller.
  #
  def can_perform?
    controller = params[:controller].split('/').last
    action = params[:action]
    unless @current_user.can_perform?(controller.camelize, action, { :special => true })
      flash[:notice] = "#{@current_user.roles.capitalize} can't go to #{action} on #{controller.humanize.downcase}."
      redirect_to :back rescue redirect_to typus_dashboard_url
    end
  end

end