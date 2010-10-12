require 'typus/authentication/fake_user'

module Typus

  module Authentication

    module None

      include Base

      def authenticate
        @current_user = FakeUser.new
      end

    end

  end

end
