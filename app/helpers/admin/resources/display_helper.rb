module Admin::Resources::DisplayHelper

  def mdash
    '&mdash;'.html_safe
  end

  def build_display(item, fields)
    fields.map do |attribute, type|
      condition = (type == :boolean) || item.send(attribute).present?
      next unless condition
      [@resource.human_attribute_name(attribute), send("display_#{type}", item, attribute)]
    end.compact
  end

end
