module Typus
  module Orm
    module ActiveRecord
      module InstanceMethods

        # This method should be moved to the user class.
        def owned_by?(user)
          send(Typus.user_fk) == user.id
        end

      end
    end
  end
end
