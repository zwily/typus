require "typus/orm/mongo/class_methods"

class Hit

  include Mongoid::Document
  extend Typus::Orm::Mongo::ClassMethods

  field :name
  field :description

  validates_presence_of :name
  validates_uniqueness_of :name

  def self.typus_fields_for(*args)
    [[:name, :string], [:description, :text]]
  end

  def self.model_fields
    [[:name, :string], [:description, :text]]
  end

end
