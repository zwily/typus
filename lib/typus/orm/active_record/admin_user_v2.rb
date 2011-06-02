require 'typus/orm/active_record/user/instance_methods'
require 'bcrypt'

module Typus
  module Orm
    module ActiveRecord
      module AdminUserV2

        module ClassMethods

          def has_admin

            attr_reader   :password
            attr_accessor :password_confirmation
            attr_protected :status

            validates :email, :presence => true, :uniqueness => true, :format => { :with => Typus::Regex::Email }
            validates :password, :confirmation => true
            validates :password_digest, :presence => true

            validate :password_must_be_strong

            include InstanceMethodsOnActivation
            include Typus::Orm::ActiveRecord::User::InstanceMethods

            serialize :preferences

            before_save :set_token

            def self.role
              Typus::Configuration.roles.keys.sort
            end

            def self.locale
              Typus.locales
            end

            def self.authenticate(email, password)
              user = find_by_email_and_status(email, true)
              user && user.authenticate(password) ? user : nil
            end

          end

        end

        module InstanceMethodsOnActivation

          # Returns self if the password is correct, otherwise false.
          def authenticate(unencrypted_password)
            if BCrypt::Password.new(password_digest) == unencrypted_password
              self
            else
              false
            end
          end

          # Encrypts the password into the password_digest attribute.
          def password=(unencrypted_password)
            @password = unencrypted_password
            self.password_digest = BCrypt::Password.create(unencrypted_password)
          end

          def set_token
            self.token = "#{ActiveSupport::SecureRandom.hex(6)}-#{ActiveSupport::SecureRandom.hex(6)}"
          end

          def password_must_be_strong
            if password.present?
              errors.add(:password, :too_short, :count => 7) unless password.size > 6
            end
          end

        end

      end
    end
  end
end
