class ActiveRecord::Base

  def to_dom(*args)

    options = args.extract_options!
    display_id = new_record? ? 'new' : id

    [ options[:prefix], 
      self.class.name.underscore, 
      display_id, 
      options[:suffix] ].compact.join('_')

  end

  ##
  # respond_to?(:name) ? name : "#{self.class}##{id}"
  #
  def to_label
    [ :typus_name, :name ].each do |attribute|
      return send(attribute).to_s if respond_to?(attribute)
    end
    return "#{self.class}##{id}"
  end

end
