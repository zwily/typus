module Typus

  module Authentication

    module None

      def authenticate
        @current_user = Admin::FakeUser.new
      end

      def check_if_user_can_perform_action_on_user; end
      def check_if_user_can_perform_action_on_resources; end
      def check_if_user_can_perform_action_on_resource; end

      def check_resource_ownership; end
      def check_resource_ownerships; end

      def check_ownership_of_referal_item; end

      def set_conditions; end

      def set_attributes_on_create; end
      def set_attributes_on_update;end

      def reload_locales;end

    end

  end

end
