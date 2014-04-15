module Admin::Resources::DisplayHelper

  def mdash
    '&mdash;'.html_safe
  end

  def build_display(item, fields)
    fields.map do |attribute, type|
      condition = (type == :boolean) || item.send(attribute).present?
      value = condition ? send("display_#{type}", item, attribute) : mdash
      [@resource.human_attribute_name(attribute), value]
    end
  end

end
