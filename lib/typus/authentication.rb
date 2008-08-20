module Authentication

  protected

    ##
    # Before doing nothing on Typus require_login
    #
    def require_login
      redirect_to typus_login_url(:back_to => request.env['REQUEST_PATH']) unless session[:typus]
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
    end

    ##
    #
    #
    def generate_password(length=8)
      chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
      password = ""
      1.upto(length) { |i| password << chars[rand(chars.size - 1)] }
      return password
    end

    ##
    # Logger user can create records?
    #
    def can_create?(model = @model)
      unless @current_user.models[model.to_s].include? "c"
        case params[:action]
        when 'new'
          flash[:notice] = "#{@current_user.roles.capitalize} cannot add new items."
        when 'create'
          flash[:notice] = "#{@current_user.roles.capitalize} cannot create new items."
        end
        redirect_to :back
      end
    end

    ##
    # Logged user can read records?
    #
    #   @current_user.can_read?
    #
    def can_read?(model = @model)
      unless @current_user.models[model.to_s].include? "r"
        flash[:notice] = "#{@current_user.roles.capitalize} cannot #{params[:action]} items."
        redirect_to :back
      end
    end

    ##
    # Logged user can update records?
    #
    def can_update?(model = @model)
      unless @current_user.models[model.to_s].include? "u"
        flash[:notice] = "#{@current_user.roles.capitalize} cannot #{params[:action]} items."
        redirect_to :back
      end
    end

    ##
    # Logger user can destroy records?
    #
    def can_destroy?(model = @model)
      unless @current_user.models[model.to_s].include? "d"
        flash[:notice] = "#{@current_user.roles.capitalize} cannot #{params[:action]} this item."
        redirect_to :back
      end
    end

end