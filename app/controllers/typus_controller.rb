class TypusController < ApplicationController

  include Authentication

  filter_parameter_logging :password

  before_filter :require_login, :only => [ :dashboard ]
  before_filter :current_user, :only => [ :dashboard ]

  before_filter :password_recover_disabled?, :only => [ :email_password ]

  ##
  # Application Dashboard
  #
  def dashboard
  end

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
  def recover_password
    if request.post?
      typus_user = TypusUser.find_by_email(params[:user][:email])
      if typus_user
        typus_user.reset_password(request.env['HTTP_HOST'])
        flash[:success] = "Password recovery link sent to your email."
        redirect_to typus_login_url
      else
        redirect_to typus_recover_password_url
      end
    else
      render :layout => 'typus_login'
    end
  end

  def reset_password
    if request.post?
      typus_user = TypusUser.find_by_token(params[:user][:token])
      if typus_user.update_attributes(params[:user])
        flash[:success] = "You can login with your new password."
        redirect_to typus_login_url
      else
        flash[:error] = "Passwords don't match."
        redirect_to :action => 'reset_password', :token => params[:user][:token]
      end
    else
      if TypusUser.find_by_token(params[:token])
        render :layout => 'typus_login'
      else
        render :text => "A valid token is required."
      end
    end
  end

private

  def password_recover_disabled?
    redirect_to typus_login_url unless Typus::Configuration.options[:password_recover]
  end

end