class ActiveRecord::Base

  ##
  #     >> Post.to_resource
  #     => "posts"
  #     >> Admin::Post.to_resource
  #     => "admin/posts"
  #
  def self.to_resource
    name.underscore.pluralize
  end

  # TODO: This should be removed to make Typus compatible 
  #       with Rails 3 new interface.
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

  def to_label
    respond_to?(:name) ? send(:name) : [ self.class, id ].join("#")
  end

end
