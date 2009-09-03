module Typus

  module Locale

    def set_locale
      if params[:locale]
        I18n.locale = params[:locale]
        session[:typus_locale] = params[:locale]
        @current_user.update_attributes :preferences => { :locale => params[:locale] }
        redirect_to request.referer || admin_dashboard_path
      else
        begin
          I18n.locale = @current_user.preferences[:locale]
        rescue
          @current_user.update_attributes :preferences => { :locale => params[:locale] }
          retry
        end
      end
    end

    def set_default_locale
      I18n.locale = Typus.default_locale
    end

  end

end