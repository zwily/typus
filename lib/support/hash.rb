class Hash

  def cleanup
    whitelist = %w(controller action id _input _popup resource attribute)
    delete_if { |k, _| !whitelist.include?(k) }
  end

end
