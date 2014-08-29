class Hash

  # Rails 4.1 now implements Hash#compact, but we want to be 4.0 compatible.
  unless {}.respond_to?(:compact)
    def compact
      delete_if { |k, v| v.blank? }
    end
  end

  def cleanup
    whitelist = %w(controller action id _input _popup resource attribute)
    delete_if { |k, _| !whitelist.include?(k) }
  end

end
