class ActiveRecord::Base

  def self.relationship_with(model)
    association = reflect_on_association(model.table_name.to_sym) ||
                  reflect_on_association(model.model_name.underscore.to_sym)
    association.macro
  end

  #--
  #     >> Post.to_resource
  #     => "posts"
  #     >> Admin::User.to_resource
  #     => "admin/users"
  #++
  def self.to_resource
    name.underscore.pluralize
  end

  #--
  # On a model:
  #
  #     class Post < ActiveRecord::Base
  #       STATUS = {  t("Published") => "published",
  #                   t("Pending") => "pending",
  #                   t("Draft") => "draft" }
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
  #++
  def mapping(attribute)
    values = self.class::const_get(attribute.to_s.upcase).to_a
    array = values.first.is_a?(Array) ? values : values.map { |i| [i, i] }
    array.rassoc(send(attribute)).first
  end

  def to_label
    respond_to?(:name) ? send(:name) : [self.class, id].join("#")
  end

end
