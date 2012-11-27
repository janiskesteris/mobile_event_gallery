module PendingImage
  class Builder
    SANITIZE_REGEXP = /(\"|\')/

    def initialize(images_attributes)
      @images_attributes = images_attributes
      sanitize_attributes!
    end

    def images
      valid_images
    end

    private

    def valid_images
      @valid_images ||= initialized_images.select { |image| image.new_record? && image.import_remote_photo! and image.valid? }
    end

    def initialized_images
      unique_image_attributes.map do |image_attributes|
        Image.where(etag: image_attributes["etag"]).first_or_initialize(
            uploaded_at: image_attributes["date"],
            content_type: image_attributes["content-type"],
            url: image_attributes["url"])
      end
    end

    def unique_image_attributes
      @images_attributes.uniq { |image_attributes| image_attributes["etag"] }
    end

    def sanitize_attributes!
      @images_attributes.collect! do |image_attributes|
        image_attributes.update(image_attributes) { |key, value| value.gsub(SANITIZE_REGEXP, "") }
      end
    end

  end
end
