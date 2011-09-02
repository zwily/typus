class Hash

  def compact
    delete_if { |k, v| v.blank? }
  end

  def cleanup
    whitelist = %w(controller action id
                   _input
                   _popup
                   resource
                   selected
                   attribute
                   back_to)
    delete_if { |k, v| !whitelist.include?(k) }
  end

end
