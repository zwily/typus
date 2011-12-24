class Hit

  if defined?(Mongoid)
    include Mongoid::Document

    field :name
    field :description

    validates_presence_of :name
    validates_uniqueness_of :name
  else
    extend ActiveModel::Naming
  end

  def self.model_fields
    hash = ActiveSupport::OrderedHash.new
    hash[:name] = :string
    hash[:description] = :text
    hash
  end

end
