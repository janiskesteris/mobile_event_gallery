module PendingImage
  class Builder
    def initialize(images_attributes)
      @images_attributes = images_attributes
    end

    def images
      valid_images
    end

    private

    def valid_images
      @valid_images ||= initialized_images.select { |image| image.import_remote_photo! and image.valid? }
    end

    def initialized_images
      @images_attributes.map do |image_attributes|
        Image.new(
            etag: image_attributes["etag"],
            uploaded_at: image_attributes["date"],
            content_type: image_attributes["content-type"],
            url: image_attributes["url"])
      end
    end

  end
end
