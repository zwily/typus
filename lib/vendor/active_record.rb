class ActiveRecord::Base

  def to_dom(*args)

    options = args.extract_options!
    display_id = new_record? ? 'new' : id

    dom = []
    dom << options[:prefix]
    dom << self.class.name.underscore
    dom << display_id
    dom << options[:suffix]

    return dom.compact.join("_")

  end

end