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

  def typus_relationships
    String.new.tap do |html|
      @resource.typus_defaults_for(:relationships).each do |relationship|
        association = @resource.reflect_on_association(relationship.to_sym)
        next if association.macro == :belongs_to
        next if admin_user.cannot?('read', association.class_name.typus_constantize)
        html << send("typus_form_#{association.macro}", relationship)
      end
    end.html_safe
  end

end
