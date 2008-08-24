class String

  def modelize
    self.singularize.camelize.constantize
  end

  def to_class
    modelize
  end

end