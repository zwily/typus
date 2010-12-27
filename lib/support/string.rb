class String

  def extract_settings
    split(",").map { |x| x.strip }
  end

  def remove_prefix
    split("/")[1..-1].join("/")
  end

  def extract_class
    remove_prefix.classify.typus_constantize
  end

  def typus_constantize
    Typus::Configuration.models_constantized[self]
  end

  def action_mapper
    case self
    when "index" then :list
    when "new", "create", "edit", "update" then :form
    else self
    end
  end

  def to_resource
    self.underscore.pluralize
  end

end
