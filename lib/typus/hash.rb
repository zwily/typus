class Hash

  def compact
    delete_if {|key, value| value.nil? || value.empty?}
  end

end