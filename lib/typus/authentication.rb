module Typus

  module Authentication

    case Typus.authentication
    when :none then
      include Authentication::None
    when :http_basic
      include Authentication::HttpBasic
    when :session
      include Authentication::Session
    end

  end

end
