if defined?(Mongoid)
  require 'lib/typus/orm/mongoid/class_methods'
  Mongoid::Document::ClassMethods.send(:include, Typus::Orm::Mongoid::ClassMethods)
end
