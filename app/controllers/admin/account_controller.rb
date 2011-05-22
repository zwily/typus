class Admin::AccountController < Admin::BaseController

  layout 'admin/session'

  skip_before_filter :reload_config_and_roles
  skip_before_filter :authenticate
  skip_before_filter :set_locale

  before_filter :sign_in?, :except => [:forgot_password, :send_password, :show]
  before_filter :new?, :only => [:forgot_password, :send_password]

  def new
    flash[:notice] = Typus::I18n.t("Enter your email below to create the first user.")
  end

  def create
    user = Typus.user_class.generate(:email => params[:typus_user][:email])
    user.status = true
    if user.save
      session[:typus_user_id] = user.id
      redirect_to :controller => "/admin/#{Typus.user_class.to_resource}", :action => "edit", :id => user.id
    else
      redirect_to :action => :new
    end
  end

  def forgot_password
  end

  def send_password
    if user = Typus.user_class.find_by_email(params[:typus_user][:email])
      url = admin_account_url(user.token)
      Admin::Mailer.reset_password_link(user, url).deliver
      redirect_to new_session_path, :notice => Typus::I18n.t("Password recovery link sent to your email.")
    else
      render :action => :forgot_password
    end
  end

  def show
    flash[:notice] = Typus::I18n.t("Please set a new password.")
    typus_user = Typus.user_class.find_by_token!(params[:id])
    session[:typus_user_id] = typus_user.id
    redirect_to :controller => "/admin/#{Typus.user_class.to_resource}", :action => "edit", :id => typus_user.id
  end

  private

  def sign_in?
    redirect_to new_session_path unless zero_users
  end

  def new?
    redirect_to new_account_path if zero_users
  end

end
