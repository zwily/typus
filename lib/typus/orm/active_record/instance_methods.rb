module Typus
  module Orm
    module ActiveRecord
      module InstanceMethods

        def owned_by?(user)
          send(Typus.user_fk) == user.id
        end

      end
    end
  end
end
