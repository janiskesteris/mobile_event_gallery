class Image < ActiveRecord::Base
  SANITIZE_REGEXP = /(\"|\')/
  validates :etag, :content_type, :url, :photo, presence: true

  after_initialize :sanitize_attributes, :if => -> image { image.new_record? }
  mount_uploader :photo, PhotoUploader
  scope :unprocessed, where(state: :pending)


  def import_remote_photo!
    self.remote_photo_url = url
    self.photo?
  end

  class << self

    def fetch_and_store_remote!
      parsed_json = PendingImage::Request.new.parsed_json
      images = PendingImage::Builder.new(parsed_json).images
      remote_image_collection = PendingImage::Collection.new(images, except_etags: existing_image_etags)
      remote_image_collection.save!
    end

    def existing_image_etags
      Image.all.map(&:etag)
    end

  end

  private

  def sanitize_attributes
    [:etag, :content_type, :url].each do |sanitizeable_attribute|
      value = self.send(sanitizeable_attribute)
      self.send("#{sanitizeable_attribute}=", value.gsub(SANITIZE_REGEXP, "")) if value
    end
  end
end
