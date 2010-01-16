if Typus::Configuration.options[:user_class_name] == 'TypusUser'

  class TypusUser < ActiveRecord::Base
    enable_as_typus_user
  end

end
