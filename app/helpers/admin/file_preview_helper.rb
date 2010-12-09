module Admin

  module FilePreviewHelper

    def get_type_of_attachment(attachment)
      if defined?(Paperclip) && attachment.is_a?(Paperclip::Attachment)
        :paperclip
      elsif defined?(Dragonfly) && attachment.is_a?(Dragonfly::ActiveModelExtensions::Attachment)
        :dragonfly
      end
    end

    def link_to_detach_attribute(attribute)
      validators = @item.class.validators.delete_if { |i| i.class != ActiveModel::Validations::PresenceValidator }.map { |i| i.attributes.to_s }.flatten

      attachment = @item.send(attribute)

      field = case get_type_of_attachment(attachment)
                 when :dragonfly then attribute
                 when :paperclip then "#{attribute}_file_name"
                 end

      if !validators.include?(field) && attachment
        attribute_i18n = @item.class.human_attribute_name(attribute)
        message = _t("Remove %{attribute}", :attribute => attribute_i18n)
        label_text = <<-HTML
#{attribute_i18n}
<small>#{link_to message, { :action => 'detach', :id => @item.id, :attribute => attribute }, :confirm => _t("Are you sure?")}</small>
        HTML
        label_text.html_safe
      end
    end

    def typus_file_preview(item, attribute)
      if (attachment = item.send(attribute))
        case get_type_of_attachment(attachment)
        when :dragonfly
          typus_file_preview_for_dragonfly(item, attribute)
        when :paperclip
          typus_file_preview_for_paperclip(item, attribute)
        end
      end
    end

    def typus_file_preview_for_dragonfly(item, attribute)
      if item.send(attribute).mime_type =~ /^image\/.+/
        render "admin/helpers/preview/dragonfly", { :item => item, :attribute => attribute }
      else
        link_to item.send(attribute).name, item.send(attribute).url
      end
    end

    def typus_file_preview_for_paperclip(item, attribute)
      if item.send(attribute).content_type =~ /^image\/.+/
        render "admin/helpers/preview/paperclip", { :item => item, :attribute => attribute }
      else
        link_to item.send(attribute).original_filename, item.send(attribute).url
      end
    end

  end

end
