module Admin

  module FilePreviewHelper

    def link_to_detach_attribute(attribute, type)
      validators = @item.class.validators.delete_if { |i| i.class != ActiveModel::Validations::PresenceValidator }.map { |i| i.attributes.to_s }.flatten

      required = case type
                 when :dragonfly
                   !validators.include?(attribute) && @item.send(attribute).present?
                 when :paperclip
                   !validators.include?("#{attribute}_file_name") && @item.send(attribute).exists?
                 end

      if required
        attribute_i18n = @item.class.human_attribute_name(attribute)
        message = _t("Remove %{attribute}", :attribute => attribute_i18n)
        label_text = <<-HTML
#{attribute_i18n}
<small>#{link_to message, { :action => 'detach', :id => @item.id, :attribute => attribute }, :confirm => _t("Are you sure?")}</small>
        HTML
        label_text.html_safe
      end
    end

    def typus_preview(item, attribute, type)
      case type
      when :paperclip then typus_preview_for_paperclip(item, attribute)
      when :dragonfly then typus_preview_for_dragonfly(item, attribute)
      end
    end

    def typus_preview_for_dragonfly(item, attribute)
      if item.send(attribute).present?
        options = { :item => item, :attribute => attribute }

        if item.send(attribute).mime_type =~ /^image\/.+/
          render "admin/helpers/preview/dragonfly", options
        else
          link_to item.send(attribute).name, item.send(attribute).url
        end
      end
    end

    def typus_preview_for_paperclip(item, attribute)
      if item.send(attribute).exists?
        options = { :item => item, :attribute => attribute }

        if item.send(attribute).content_type =~ /^image\/.+/
          render "admin/helpers/preview/paperclip", options
        else
          link_to item.send(attribute).original_filename, item.send(attribute).url
        end
      end
    end

  end

end
