class String

  def extract_settings
    gsub(/ /, '').split(',')
  end

  def extract_controller(admin = 'admin')
    split('/').delete_if { |i| i.eql?(admin) }
  end

  def extract_resource
    extract_controller.join('/')
  end

  def extract_class
    extract_controller.map { |i| i.capitalize }.join('::').classify.constantize
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
