if Rails.env.production?

  #
  # use locale fallback; i.e. better show the wrong text than raise an exception
  #
  # fallbacks work as follows:
  #   * all parent locales of a given locale (e.g. :es for :"es-MX") are checked first
  #   * then current default locales and all of their parents
  #
  # more info on fallback sequence and how to set up own fallbacks: 
  #   * https://github.com/svenfuchs/i18n/blob/master/lib/i18n/locale/fallbacks.rb
  #
  I18n::Backend::Simple.include(I18n::Backend::Fallbacks)
else

  #
  # raise an exception so the error can be fixed right away
  #
  class I18n::RaiseExceptionHandler < I18n::ExceptionHandler
    def call(exception, locale, key, options)
      if exception.is_a?(I18n::MissingTranslation)
        raise exception.to_exception
      else
        super
      end
    end
  end

  I18n.exception_handler = I18n::RaiseExceptionHandler.new
end

#I18n.available_locales = [:ca, :es, :it, :de, :en]

#
# This should be set in your application:
#
#I18n.enforce_available_locales = true
#I18n.default_locale = :en
#p I18n.available_locales