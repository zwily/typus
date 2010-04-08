class ActiveRecord::Base

  # Merges conditions so that the result is a valid +condition+
  def self.merge_conditions(*conditions)

    segments = []

    conditions.each do |condition|
      unless condition.blank?
        sql = sanitize_sql(condition)
        segments << sql unless sql.blank?
      end
    end

    "(#{segments.join(') AND (')})" unless segments.empty?

  end

  def to_dom(*args)

    options = args.extract_options!
    display_id = new_record? ? "new" : id

    [ options[:prefix], 
      self.class.name.underscore, 
      display_id, 
      options[:suffix] ].compact.join("_")

  end

  ##
  # On a model:
  #
  #     class Post < ActiveRecord::Base
  #       STATUS = { "published" => t("Published"), 
  #                  "pending" => t("Pending"), 
  #                  "draft" => t("Draft") }
  #     end
  #
  #     >> Post.first.status
  #     => "published"
  #     >> Post.first.mapping(:status)
  #     => "Published"
  #     >> I18n.locale = :es
  #     => :es
  #     >> Post.first.mapping(:status)
  #     => "Publicado"
  #
  def mapping(attribute)
    values = self.class::const_get(attribute.to_s.upcase)
    values.kind_of?(Hash) ? values[send(attribute)] : send(attribute)
  end

  ##
  # ActiveScaffold uses `to_label`, which makes more sense. We want 
  # to keep compatibility with old versions of Typus. The prefered method 
  # is `to_label` and `typus_name` will be deprecated in the next months.
  #
  def to_label
    [ :typus_name, :name ].each do |attribute|
      return send(attribute) if respond_to?(attribute)
    end
    return [ self.class, id ].join("#")
  end

end
