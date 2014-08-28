module Admin::Resources::DataTypes::StringHelper

  def display_string(item, attribute)
    item.send(attribute)
  end

  alias_method :display_decimal, :display_string
  alias_method :display_float, :display_string
  alias_method :display_integer, :display_string
  alias_method :display_position, :display_string
  alias_method :display_text, :display_string
  alias_method :display_virtual, :display_string

  def string_filter(filter)
    values = set_context.send(filter.to_s.pluralize).to_a
    attribute = @resource.human_attribute_name(filter)

    items = [[attribute.capitalize, '']]
    array = values.first.is_a?(Array) ? values : values.map { |i| ["#{attribute}:#{i}", i] }

    items + array
  end

  def table_string_field(attribute, item)
    (raw_content = item.send(attribute)).present? ? raw_content : mdash
  end

  alias_method :table_decimal_field, :table_string_field
  alias_method :table_float_field, :table_string_field
  alias_method :table_integer_field, :table_string_field
  alias_method :table_virtual_field, :table_string_field
  alias_method :table_password_field, :table_string_field

end
