module Admin

  module PreviewHelper

    def typus_preview(item, attribute)

      return unless item.attachment_present?(attribute)

      attachment = attribute.split("_file_name").first
      file_preview = Typus.file_preview
      file_thumbnail = Typus.file_thumbnail

      has_file_preview = item.send(attachment).styles.member?(file_preview)
      has_file_thumbnail = item.send(attachment).styles.member?(file_thumbnail)
      file_preview_is_image = item.send("#{attachment}_content_type") =~ /^image\/.+/

      href = if has_file_preview
               url = item.send(attachment).url(file_preview)
               # FIXME: This has changed on Rails3.
               # ActionController::Base.relative_url_root + url
             else
               item.send(attachment).url
             end

      content = if has_file_thumbnail
                  image_tag item.send(attachment).url(file_thumbnail)
                else
                  item.send(attribute)
                end

      render "admin/helpers/preview", 
             :attribute => attribute, 
             :content => content, 
             :has_file_preview => has_file_preview, 
             :href => href, 
             :item => item

    end

  end

end
