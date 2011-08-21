module Admin::Resources::DisplayHelper

  def mdash
    "&mdash;".html_safe
  end

  def build_display(item, fields)
    fields.map do |attribute, type|
      value = if (type == :boolean) || (data = item.send(attribute)).present?
                send("display_#{type}", item, attribute)
              else
                mdash
              end

      [@resource.human_attribute_name(attribute), value]
    end
  end

  def typus_relationships
    String.new.tap do |html|
      @resource.typus_defaults_for(:relationships).each do |relationship|
        association = @resource.reflect_on_association(relationship.to_sym)
        next if association.macro == :belongs_to
        next if association.macro == :has_and_belongs_to_many
        next if admin_user.cannot?('read', association.class_name.constantize)
        html << send("typus_form_#{association.macro}", relationship)
      end
    end.html_safe
  end

end
