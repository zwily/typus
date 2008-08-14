class TypusController < ApplicationController

  include Authentication

  filter_parameter_logging :password
  before_filter :current_user, :only => [ :dashboard ]

  ##
  # Login
  #
  def login
    if request.post?
      @user = TypusUser.authenticate(params[:user][:email], params[:user][:password])
      if @user
        session[:typus] = @user.id
        if params[:back_to]
          redirect_to params[:back_to]
        else
          redirect_to typus_dashboard_url
        end
      else
        flash[:error] = "The Email and/or Password you entered is invalid."
        redirect_to typus_login_url
      end
    else
      render :layout => 'typus_login'
    end
  end

  ##
  # Logout and redirect to +typus_login+.
  #
  def logout
    session[:typus] = nil
    redirect_to typus_login_url
  end

  ##
  # Email password when lost
  #
  def email_password
    if request.post?
      typus_user = TypusUser.find_by_email(params[:user][:email])
      if typus_user
        password = generate_password
        host = request.env['HTTP_HOST']
        typus_user.reset_password(password, host)
        flash[:success] = "New password sent to #{params[:user][:email]}"
        redirect_to typus_login_url
      else
        flash[:error] = "Email doesn't exist on the system."
        redirect_to typus_email_password_url
      end
    else
      render :layout => 'typus_login'
    end
  end

  ##
  # Application Dashboard
  #
  def dashboard
  end

end