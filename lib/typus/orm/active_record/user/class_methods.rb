module Typus
  module Orm
    module ActiveRecord
      module User
        module ClassMethods

          def generate(*args)
            options = args.extract_options!
            options[:password] ||= Typus.password
            options[:role] ||= Typus.master_role
            user = new :email => options[:email], :password => options[:password]
            user.status = true
            user.role = options[:role]
            user.save ? user : false
          end

          def role
            Typus::Configuration.roles.keys.sort
          end

          def locale
            Typus.locales
          end

        end
      end
    end
  end
end
