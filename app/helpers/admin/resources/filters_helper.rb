module Admin::Resources::FiltersHelper

  def build_filters(resource = @resource, params = params)
    typus_filters = resource.typus_filters

    return if typus_filters.empty?

    filters = typus_filters.map do |key, value|
                { :filter => set_filter(key, value), :items => send("#{value}_filter", key) }
              end

    hidden_filters = params.dup

    # Remove default params.
    rejections = %w(controller action locale utf8 sort_order order_by)
    hidden_filters.delete_if { |k, v| rejections.include?(k) }

    # Remove also custom params.
    rejections = filters.map { |i| i[:filter] }
    hidden_filters.delete_if { |k, v| rejections.include?(k) }

    locals = { :filters => filters, :hidden_filters => hidden_filters }

    render "helpers/admin/resources/filters/filters", locals
  end

  def set_filter(key, value)
    case value
    when :belongs_to
      att_assoc = @resource.reflect_on_association(key.to_sym)
      class_name = att_assoc.options[:class_name] || key.capitalize.camelize
      resource = class_name.typus_constantize
      att_assoc.foreign_key
    else
      key
    end
  end

  def predefined_filters
    @predefined_filters ||= []
  end

end
