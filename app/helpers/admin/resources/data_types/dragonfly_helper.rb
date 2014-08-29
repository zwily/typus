module Admin::Resources::DataTypes::DragonflyHelper

  def table_dragonfly_field(attribute, item)
    typus_dragonfly_preview(item, attribute)
  end

  def link_to_detach_attribute_for_dragonfly(attribute)
    validators = @item.class.validators.delete_if { |i| i.class != ActiveRecord::Validations::PresenceValidator }.map(&:attributes).flatten.map(&:to_s)
    attachment = @item.send(attribute)

    if attachment.present? && !validators.include?(attribute) && attachment
      attribute_i18n = @item.class.human_attribute_name(attribute)

      link = link_to Typus::I18n.t('Remove'), { action: 'update', id: @item.id, _nullify: attribute, _continue: true }, { data: { confirm: Typus::I18n.t('Are you sure?') } }

      label_text = <<-HTML
#{attribute_i18n}
<small>#{link}</small>
      HTML
      label_text.html_safe
    end
  end

  def typus_dragonfly_preview(item, attachment)
    data = item.send(attachment)
    return unless data

    if data.mime_type =~ /^image\/.+/
      render 'admin/templates/dragonfly_preview',
             attachment: data,
             preview: data.process(:thumb, Typus.image_preview_size).url,
             thumb: data.process(:thumb, Typus.image_table_thumb_size).url,
             item: item,
             attribute: attachment
    else
      params[:_popup] ? data.name : link_to(data.name, data.url)
    end
  end

  def typus_dragonfly_form_preview(item, attachment, options = {})
    data = item.send(attachment)
    return unless data

    if data.mime_type =~ /^image\/.+/
      render 'admin/templates/dragonfly_form_preview',
             attachment: data,
             preview: data.thumb(Typus.image_preview_size).url,
             thumb: data.thumb(Typus.image_thumb_size).url,
             options: options,
             item: item,
             attribute: attachment
    else
      params[:_popup] ? data.name : link_to(data.name, data.url, {target: '_blank'})
    end
  end

end
