module Typus

  module Authentication

    module None

      include Base

      def authenticate
        @current_user = Admin::FakeUser.new
      end

    end

  end

end
