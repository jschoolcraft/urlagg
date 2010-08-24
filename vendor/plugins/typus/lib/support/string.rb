class String

  def extract_settings
    split(",").map { |x| x.strip }
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
    extract_class.model_name.human.gsub('/', ' ')
  end

  #--
  # OPTIMIZE: Find a way to remove the rescue.
  #++
  def typus_actions_on(filter)
    if settings = Typus::Configuration.config[self]['actions'][filter.to_s]
      settings.extract_settings
    else
      []
    end
  rescue
    []
  end

  #--
  # OPTIMIZE: Find a way to remove the rescue.
  #++
  def typus_defaults_for(filter)
    if settings = Typus::Configuration.config[self][filter.to_s]
      settings.extract_settings
    else
      []
    end
  end

end
