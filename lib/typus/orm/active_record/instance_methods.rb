module Typus
  module Orm
    module ActiveRecord
      module InstanceMethods

        ##
        # TODO: Move this methos to the User::InstancheMethods module.
        #
        def owned_by?(user)
          send(Typus.user_fk) == user.id
        end

      end
    end
  end
end
