module Typus

  module Authentication

    case Typus.authentication
    when :none
      require "typus/authentication/none"
      include Typus::Authentication::None
    when :basic
      require "typus/authentication/basic"
      include Typus::Authentication::Basic
    when :advanced
      require "typus/authentication/advanced"
      include Typus::Authentication::Advanced
    end

  end

end
