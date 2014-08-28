module Admin::Resources::DataTypes::IntegerHelper

  def integer_filter(filter)
    values = set_context.send(filter.to_s.pluralize).to_a
    attribute = @resource.human_attribute_name(filter)

    items = [[attribute.titleize, '']]
    array = values.first.is_a?(Array) ? values : values.map { |i| ["#{attribute}:#{i}", i] }

    items + array
  end

end
