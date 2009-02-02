class TypusController < ApplicationController

  layout :select_layout

  include Authentication
  include Typus::Configuration::Reloader

  if Typus::Configuration.options[:ssl]
    include SslRequirement
    ssl_required :dashboard, :overview, :login, :logout, :recover_password, :reset_password
  end

  filter_parameter_logging :password

  before_filter :reload_config_et_roles
  before_filter :require_login, :except => [ :login, :logout, :recover_password, :reset_password, :setup ]

  before_filter :check_if_user_can_perform_action_on_resource_without_model, :except => [ :overview, :dashboard, :login, :logout, :recover_password, :reset_password, :setup ]

  before_filter :recover_password_disabled?, :only => [ :recover_password, :reset_password ]

  ##
  # Application Dashboard
  #
  def dashboard
    flash[:notice] = t("There are not defined applications in config/typus/*.yml.") if Typus.applications.empty?
  end

  ##
  # Configuration Overview
  #
  def overview
  end

  ##
  # Login
  #
  def login

    redirect_to :action => 'setup' and return if Typus.user_class.count.zero?

    if request.post?
      user = Typus.user_class.authenticate(params[:user][:email], params[:user][:password])
      if user
        session[:typus] = user.id
        redirect_to params[:back_to] || admin_dashboard_url
      else
        flash[:error] = t("The Email and/or Password you entered is invalid.")
        redirect_to admin_login_url
      end
    end

  end

  ##
  # Logout and redirect to +admin_login+.
  #
  def logout
    session[:typus] = nil
    redirect_to admin_login_url
  end

  ##
  # Email password when lost
  #
  def recover_password
    if request.post?
      user = Typus.user_class.find_by_email(params[:user][:email])
      if user
        ActionMailer::Base.default_url_options[:host] = request.host_with_port
        TypusMailer.deliver_reset_password_link(user)
        flash[:success] = t("Password recovery link sent to your email.")
        redirect_to admin_login_url
      else
        redirect_to admin_recover_password_url
      end
    end
  end

  ##
  # Available if Typus::Configuration.options[:recover_password] is
  # enabled. Enabled by default.
  #
  def reset_password
    @user = Typus.user_class.find_by_token!(params[:token])
    if request.post?
      if @user.update_attributes(params[:user])
        flash[:success] = t("You can login with your new password.")
        redirect_to admin_login_url
      else
        flash[:error] = t("Passwords don't match.")
        redirect_to :action => 'reset_password', :token => params[:token]
      end
    end
  end

  def setup

    redirect_to :action => 'login' and return unless Typus.user_class.count.zero?

    if request.post?

      password = generate_password

      user = Typus.user_class.new :email => params[:user][:email], 
                                  :password => password, 
                                  :password_confirmation => password, 
                                  :roles => Typus::Configuration.options[:root], 
                                  :status => true

      if user.save
        session[:typus] = user.id
        flash[:notice] = t("Your new password is '{{password}}'.", :password => password)
        redirect_to :action => 'dashboard'
      else
        flash[:error] = t("That doesn't seem like a valid email address.")
        redirect_to :action => 'setup'
      end

    else

      flash[:success] = t("Welcome! Write your email to create the first user.")

    end

  end

private

  def recover_password_disabled?
    redirect_to admin_login_url unless Typus::Configuration.options[:recover_password]
  end

  def select_layout
    [ 'login', 'logout', 'recover_password', 'reset_password', 'setup' ].include?(action_name) ? 'typus' : 'admin'
  end

end
