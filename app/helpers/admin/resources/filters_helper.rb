module Admin::Resources::FiltersHelper

  def build_filters(resource = @resource, params = params)
    typus_filters = resource.typus_filters

    return if typus_filters.empty?

    filters = typus_filters.map do |key, value|
                items = case value
                        when :boolean then boolean_filter(key)
                        when :string then string_filter(key)
                        when :date, :datetime, :timestamp then date_filter(key)
                        when :belongs_to then belongs_to_filter(key)
                        when :has_many, :has_and_belongs_to_many then
                          has_many_filter(key)
                        else
                          string_filter(key)
                        end

                filter = set_filter(key, value)

      { :filter => filter, :items => items }
    end

    hidden_filters = params.dup

    # Remove default params.
    rejections = %w(controller action locale utf8 sort_order order_by)
    hidden_filters.delete_if { |k, v| rejections.include?(k) }

    # Remove also custom params.
    rejections = filters.map { |i| i[:filter] }
    hidden_filters.delete_if { |k, v| rejections.include?(k) }

    render "helpers/admin/resources/filters/filters", :filters => filters, :hidden_filters => hidden_filters
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
