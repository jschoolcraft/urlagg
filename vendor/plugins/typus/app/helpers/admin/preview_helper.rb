module Admin

  module PreviewHelper

    def typus_preview(item, attribute)

      return unless item.send(attribute).exists?

      file_preview_is_image = (item.send("#{attribute}_content_type") =~ /^image\/.+/)

      unless file_preview_is_image
        file = File.basename(item.send(attribute).path(:original))
        link = link_to(file, :action => 'view', :id => item)
        return link
      end

      file = { :preview => Typus.file_preview, :thumbnail => Typus.file_thumbnail }

      has_file_preview = item.send(attribute).styles.member?(file[:preview])
      has_file_thumbnail = item.send(attribute).styles.member?(file[:thumbnail])

      href = if has_file_preview && file_preview_is_image
               url = item.send(attribute).url(file[:preview])
               # FIXME: This has changed on Rails3.
               # ActionController::Base.relative_url_root + url
             else
               item.send(attribute)
             end

      content = if has_file_thumbnail && file_preview_is_image
                  image_tag item.send(attribute).url(file[:thumbnail])
                else
                  item.send(attribute)
                end

      render "admin/helpers/preview",
             :attribute => attribute,
             :content => content,
             :file_preview_is_image => file_preview_is_image,
             :has_file_preview => has_file_preview,
             :href => href,
             :item => item

    end

  end

end
