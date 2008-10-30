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
    # Logger user can create records?
    #
    #   @current_user.can_create?
    #
    def can_create?(model = @model)
      unless @current_user.can_create? model
        case params[:action]
        when 'new'
          flash[:notice] = "#{@current_user.roles.capitalize} cannot add new items."
        when 'create'
          flash[:notice] = "#{@current_user.roles.capitalize} cannot create new items."
        end
        redirect_to :back rescue redirect_to typus_dashboard_url
      end
    end

    ##
    # Logged user can read records?
    #
    #   @current_user.can_read?
    #
    def can_read?(model = @model)
      unless @current_user.can_read? model
        flash[:notice] = "#{@current_user.roles.capitalize} cannot #{params[:action]} items."
        redirect_to :back rescue redirect_to typus_dashboard_url
      end
    end

    ##
    # Logged user can update records?
    #
    #   @current_user.can_update?
    #
    def can_update?(model = @model)
      if model.new.kind_of? TypusUser

        return if Typus::Configuration.options[:root] == @current_user.roles

        if !(params[:id] == session[:typus].to_s)
          flash[:notice] = "As you're not the admin or the owner of this record you cannot edit it."
          redirect_to :back rescue redirect_to typus_dashboard_url
        end

      else
        unless @current_user.can_update? model
          flash[:notice] = "#{@current_user.roles.capitalize} cannot #{params[:action]} items."
          redirect_to :back rescue redirect_to typus_dashboard_url
        end
      end
    end

    ##
    # Logger user can destroy records?
    #
    #   @current_user.can_destroy?
    #
    def can_destroy?(model = @model)
      unless @current_user.can_destroy? model
        flash[:notice] = "#{@current_user.roles.capitalize} cannot #{params[:action]} this item."
        redirect_to :back rescue redirect_to typus_dashboard_url
      end
    end

end