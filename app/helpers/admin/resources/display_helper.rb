module Admin::Resources::DisplayHelper

  def build_display(item, fields)
    fields.map do |attribute, type|
      value = if (type == :boolean) || (data = item.send(attribute))
                send("display_#{type}", item, attribute)
              else
                "&mdash;".html_safe
              end

      [@resource.human_attribute_name(attribute), value]
    end
  end

end
