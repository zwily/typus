class Object

  ##
  # TODO: Improve this code, which works, but probably there's a better way
  #       to make the verification.
  #
  # Probably there's a better way to verify if a model responds to an STI
  # pattern.
  def self.is_sti?
    (name != base_class.name) && base_class.descends_from_active_record?
  end

end
