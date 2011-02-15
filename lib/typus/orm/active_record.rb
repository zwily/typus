if defined?(ActiveRecord)
  require 'typus/orm/active_record/class_methods'
  ActiveRecord::Base.extend Typus::Orm::ActiveRecord::ClassMethods

  require 'typus/orm/active_record/instance_methods'
  ActiveRecord::Base.send :include, Typus::Orm::ActiveRecord::InstanceMethods

  require 'typus/orm/active_record/search'
  ActiveRecord::Base.extend Typus::Orm::ActiveRecord::Search

  require 'typus/orm/active_record/user'
  ActiveRecord::Base.extend Typus::Orm::ActiveRecord::User::ClassMethods
end
