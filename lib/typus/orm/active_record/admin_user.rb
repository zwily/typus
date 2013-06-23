require 'typus/orm/active_record/user/instance_methods'
require 'typus/orm/active_record/user/class_methods'
require 'bcrypt'

module Typus
  module Orm
    module ActiveRecord
      module AdminUser

        module ClassMethods

          def has_admin

            extend Typus::Orm::ActiveRecord::User::ClassMethods

            include Typus::Orm::ActiveRecord::User::InstanceMethods
            include InstanceMethods

            attr_reader   :password
            attr_accessor :password_confirmation

            # attr_protected :role, :status

            validates :email, :presence => true, :uniqueness => true, :format => { :with => Typus::Regex::Email }
            validates :password, :confirmation => true
            validates :password_digest, :presence => true
            validate :password_must_be_strong
            validates :role, :presence => true

            serialize :preferences

            before_save :set_token

            def authenticate(email, password)
              user = find_by_email_and_status(email, true)
              user && user.authenticated?(password) ? user : nil
            end

          end

        end

        module InstanceMethods

          def locale
            (preferences && preferences[:locale]) ? preferences[:locale] : ::I18n.default_locale
          end

          def locale=(locale)
            self.preferences ||= {}
            self.preferences[:locale] = locale
          end

          def authenticated?(unencrypted_password)
            equal = BCrypt::Password.new(password_digest) == unencrypted_password
            equal ? self : false
          end

          def password=(unencrypted_password)
            @password = unencrypted_password
            self.password_digest = BCrypt::Password.create(unencrypted_password)
          end

          def password_must_be_strong(count = 6)
            if password.present? && password.size < count
              errors.add(:password, :too_short, :count => count)
            end
          end

        end

      end
    end
  end
end
