require 'typus/authentication/base'

module Typus

  module Authentication

    case Typus.authentication
    when :none then
      require 'typus/authentication/none'
      include Typus::Authentication::None
    when :http_basic
      require 'typus/authentication/http_basic'
      include Typus::Authentication::HttpBasic
    when :session
      require 'typus/authentication/session'
      include Typus::Authentication::Session
    end

  end

end
