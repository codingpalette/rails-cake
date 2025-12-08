module CloudflareImageable
  extend ActiveSupport::Concern

  class_methods do
    def has_cloudflare_image(attribute_name, column: nil)
      column_name = column || "cloudflare_#{attribute_name}_id"

      define_method("#{attribute_name}_url") do |variant: "public"|
        image_id = send(column_name)
        CloudflareImagesService.url_for(image_id, variant: variant)
      end

      define_method("#{attribute_name}?") do
        send(column_name).present?
      end

      define_method("upload_#{attribute_name}") do |file|
        return if file.blank?

        service = CloudflareImagesService.new
        old_image_id = send(column_name)

        image_id = service.upload(file)
        update_column(column_name, image_id)

        service.delete(old_image_id) if old_image_id.present?
        image_id
      end

      define_method("delete_#{attribute_name}") do
        image_id = send(column_name)
        return unless image_id.present?

        CloudflareImagesService.new.delete(image_id)
        update_column(column_name, nil)
      end
    end

    def has_cloudflare_images(attribute_name, column: nil)
      column_name = column || "cloudflare_#{attribute_name}_ids"

      define_method("#{attribute_name}_urls") do |variant: "public"|
        image_ids = send(column_name) || []
        image_ids.map { |id| CloudflareImagesService.url_for(id, variant: variant) }
      end

      define_method("#{attribute_name}_count") do
        (send(column_name) || []).size
      end

      define_method("#{attribute_name}?") do
        (send(column_name) || []).any?
      end

      define_method("first_#{attribute_name.to_s.singularize}_url") do |variant: "public"|
        image_ids = send(column_name) || []
        return nil if image_ids.empty?
        CloudflareImagesService.url_for(image_ids.first, variant: variant)
      end

      define_method("upload_#{attribute_name}") do |files|
        return if files.blank?

        files = [files] unless files.is_a?(Array)
        files = files.reject(&:blank?)
        return if files.empty?

        service = CloudflareImagesService.new
        current_ids = send(column_name) || []

        new_ids = files.map { |file| service.upload(file) }
        update_column(column_name, current_ids + new_ids)
        new_ids
      end

      define_method("delete_#{attribute_name.to_s.singularize}") do |image_id|
        return unless image_id.present?

        current_ids = send(column_name) || []
        return unless current_ids.include?(image_id)

        CloudflareImagesService.new.delete(image_id)
        update_column(column_name, current_ids - [image_id])
      end

      define_method("delete_all_#{attribute_name}") do
        image_ids = send(column_name) || []
        return if image_ids.empty?

        service = CloudflareImagesService.new
        image_ids.each { |id| service.delete(id) rescue nil }
        update_column(column_name, [])
      end
    end
  end
end
