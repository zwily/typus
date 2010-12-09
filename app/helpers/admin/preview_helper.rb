module Admin

  module PreviewHelper

    def link_to_detach_attribute(attribute)
      # This is the validator for `paperclip`:
      validators = @item.class.validators.delete_if { |i| i.class != ActiveModel::Validations::PresenceValidator }.map { |i| i.attributes.to_s }.flatten

      # This is the validator for `dragonfly`:
      # validators = @item.class.validators.delete_if { |i| i.class != ActiveModel::Validations::PresenceValidator }.map { |i| i.attributes.to_s }.flatten

      if !validators.include?("#{attribute}_file_name") && @item.send(attribute).exists?
      # if !validators.include?(attribute) && @item.send(attribute).present?
        attribute_i18n = @item.class.human_attribute_name(attribute)
        message = _t("Remove %{attribute}", :attribute => attribute_i18n)
        label_text = <<-HTML
#{attribute_i18n}
<small>#{link_to message, { :action => 'detach', :id => @item.id, :attribute => attribute }, :confirm => _t("Are you sure?")}</small>
        HTML
        label_text.html_safe
      end
    end

    def typus_preview(item, attribute, type = :paperclip)
      case type
      when :paperclip
        typus_preview_for_paperclip(item, attribute)
      when :dragonfly
        typus_preview_for_dragonfly(item, attribute)
      end
    end

    def typus_preview_for_dragonfly(item, attribute)
      return unless item.send(attribute).present?

      options = { :item => item, :attribute => attribute }

      if item.send(attribute).mime_type =~ /^image\/.+/
        render "admin/helpers/preview/dragonfly", options
      else
        link_to item.send(attribute).name, item.send(attribute).url
      end
    end

    def typus_preview_for_paperclip(item, attribute)
      return unless item.send(attribute).exists?

      options = { :item => item, :attribute => attribute }

      if item.send(attribute).content_type =~ /^image\/.+/
        render "admin/helpers/preview/paperclip", options
      else
        link_to item.send(attribute).original_filename, item.send(attribute).url
      end
    end

  end

end
