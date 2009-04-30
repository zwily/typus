class Object

  def _(msg)
    I18n.t msg, :default => msg
  end

end