class String

  def extract_settings
    gsub(/ /, '').split(',')
  end

  def remove_prefix(prefix = 'admin/')
    partition(prefix).last
  end

  def extract_resource
    remove_prefix
  end

  def extract_class
    remove_prefix.camelize.classify.constantize
  end

  def extract_human_name
    extract_class.typus_human_name.gsub('/', ' ')
  end

  # OPTIMIZE
  def typus_actions_on(filter)
    if settings = Typus::Configuration.config[self]['actions'][filter.to_s]
      settings.extract_settings
    else
      []
    end
  rescue
    []
  end

  # OPTIMIZE
  def typus_defaults_for(filter)
    if settings = Typus::Configuration.config[self][filter.to_s]
      settings.extract_settings
    else
      []
    end
  end

end
