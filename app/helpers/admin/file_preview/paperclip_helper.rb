module Admin
  module FilePreview
    module PaperclipHelper

      def link_to_detach_attribute_for_paperclip(attribute)
        validators = @item.class.validators.delete_if { |i| i.class != ActiveModel::Validations::PresenceValidator }.map { |i| i.attributes }.flatten.map { |i| i.to_s }

        field = "#{attribute}_file_name"
        attachment = @item.send(attribute)

        present = attachment.exists?

        # Print the message if possible!
        if present && !validators.include?(field) && attachment
          attribute_i18n = @item.class.human_attribute_name(attribute)
          message = Typus::I18n.t("Remove")
          label_text = <<-HTML
  #{attribute_i18n}
  <small>#{link_to message, { :action => 'update', :id => @item.id, :attribute => attribute, :_continue => true }, :confirm => Typus::I18n.t("Are you sure?")}</small>
          HTML
          label_text.html_safe
        end
      end

      def typus_paperclip_preview(item, attachment, options = {})
        data = item.send(attachment)
        return unless data.exists?

        styles = data.styles.keys
        if data.content_type =~ /^image\/.+/ && styles.include?(Typus.file_preview) && styles.include?(Typus.file_thumbnail)
          render "admin/templates/file/paperclip_preview",
                 :preview => data.url(Typus.file_preview, false),
                 :thumb => data.url(Typus.file_thumbnail, false),
                 :options => options
        else
          link_to data.original_filename, data.url(:original, false)
        end
      end

    end
  end
end
