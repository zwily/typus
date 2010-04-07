module Typus

  module Preferences

    def set_preferences
      I18n.locale = @current_user.preferences[:locale]
    end

  end

end
