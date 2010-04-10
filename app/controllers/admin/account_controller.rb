class Admin::AccountController < AdminController

  layout "account"

  skip_before_filter :reload_config_and_roles
  skip_before_filter :set_preferences
  skip_before_filter :authenticate

  before_filter :recover_password_disabled?, 
                :only => [ :recover_password, :reset_password ]

  def sign_in

    redirect_to admin_sign_up_path and return if Typus.user_class.count.zero?

    if request.post?
      if user = Typus.user_class.authenticate(params[:typus_user][:email], params[:typus_user][:password])
        session[:typus_user_id] = user.id
        redirect_to params[:back_to] || admin_dashboard_path
      else
        flash[:error] = _("The email and/or password you entered is invalid.")
        redirect_to admin_sign_in_path(:back_to => params[:back_to])
      end
    end

  end

  def sign_out
    session[:typus_user_id] = nil
    redirect_to admin_sign_in_path
  end

  def recover_password
    if request.post?
      if user = Typus.user_class.find_by_email(params[:typus_user][:email])
        url = admin_reset_password_url(:token => user.token)
        Admin::Mailer.reset_password_link(user, url).deliver
        flash[:success] = _("Password recovery link sent to your email.")
        redirect_to admin_sign_in_path
      else
        redirect_to admin_recover_password_path
      end
    end
  end

  # Only available when Typus.email is present.
  def reset_password
    @typus_user = Typus.user_class.find_by_token!(params[:token])
    if request.post?
      @typus_user.password = params[:typus_user][:password]
      @typus_user.password_confirmation = params[:typus_user][:password_confirmation]
      if !params[:typus_user][:password].blank? && @typus_user.save
        session[:typus_user_id] = @typus_user.id
        redirect_to admin_dashboard_path
      else
        render :action => "reset_password"
      end
    end
  end

  def sign_up

    redirect_to admin_sign_in_path and return unless Typus.user_class.count.zero?

    if request.post?

      user = Typus.user_class.generate(:email => params[:typus_user][:email], 
                                       :password => Typus.default_password, 
                                       :role => Typus.master_role)
      user.status = true

      if user.save
        session[:typus_user_id] = user.id
        flash[:notice] = _("Password set to \"{{password}}\".", 
                           :password => Typus.default_password)
        redirect_to admin_dashboard_path
      else
        flash[:error] = _("That doesn't seem like a valid email address.")
      end

    else

      flash[:notice] = _("Enter your email below to create the first user.")

    end

  end

private

  def recover_password_disabled?
    redirect_to admin_sign_in_path unless Typus.email
  end

end
