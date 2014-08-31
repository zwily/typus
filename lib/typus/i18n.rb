module Typus
  module I18n

    class << self

      def default_locale
        :en
      end

      def available_locales
        {
          'Brazilian Portuguese' => 'pt-BR',
          'Català' => 'ca',
          'German' => 'de',
          'Greek'  => 'el',
          'Italiano' => 'it',
          'English' => 'en',
          'Español' => 'es',
          'Français' => 'fr',
          'Magyar' => 'hu',
          'Portuguese' => 'pt-PT',
          'Russian' => 'ru',
          '中文' => 'zh-CN',
        }
      end

    end

  end
end
