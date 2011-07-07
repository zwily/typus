module Admin::Resources::FiltersHelper

  def build_filters(resource = @resource, params = params)
    if (typus_filters = resource.typus_filters).any?
      locals = {}

      locals[:filters] = typus_filters.map do |key, value|
                           { :filter => set_filter(key, value), :items => send("#{value}_filter", key) }
                         end

      locals[:hidden_filters] = params.dup

      # Remove default params.
      rejections = %w(controller action locale utf8 sort_order order_by)
      locals[:hidden_filters].delete_if { |k, v| rejections.include?(k) }

      # Remove also custom params.
      rejections = locals[:filters].map { |f| f[:filter] }
      locals[:hidden_filters].delete_if { |k, v| rejections.include?(k) }

      render "helpers/admin/resources/filters", locals
    end
  end

  def set_filter(key, value)
    return key unless value == :belongs_to

    att_assoc = @resource.reflect_on_association(key.to_sym)
    class_name = att_assoc.options[:class_name] || key.capitalize.camelize
    resource = class_name.constantize
    att_assoc.foreign_key
  end

end
