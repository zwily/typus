class String

  def to_class
    self.singularize.camelize.constantize
  end

end