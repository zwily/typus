module Admin
  module DataTypes
    module DragonflyHelper

      def table_dragonfly_field(attribute, item)
        options = { :height => 25, :width => 25 }
        typus_dragonfly_preview(item, attribute, options)
      end

      def link_to_detach_attribute_for_dragonfly(attribute)
        validators = @item.class.validators.delete_if { |i| i.class != ActiveModel::Validations::PresenceValidator }.map { |i| i.attributes }.flatten.map { |i| i.to_s }
        attachment = @item.send(attribute)

        if attachment.present? && !validators.include?(attribute) && attachment
          attribute_i18n = @item.class.human_attribute_name(attribute)
          message = Typus::I18n.t("Remove")
          label_text = <<-HTML
#{attribute_i18n}
<small>#{link_to message, { :action => 'update', :id => @item.id, :attribute => attribute, :_continue => true }, :confirm => Typus::I18n.t("Are you sure?")}</small>
          HTML
          label_text.html_safe
        end
      end

      def typus_dragonfly_preview(item, attachment, options = {})
        data = item.send(attachment)
        return unless data

        if data.mime_type =~ /^image\/.+/
          render "admin/templates/file/dragonfly_preview",
                 :preview => data.process(:thumb, Typus.image_preview_size).url,
                 :thumb => data.process(:thumb, Typus.image_thumb_size).url,
                 :options => options
        else
          link_to data.name, data.url
        end
      end

    end
  end
end
