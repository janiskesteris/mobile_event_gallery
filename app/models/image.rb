class Image < ActiveRecord::Base
  validates :etag, :content_type, :url, :photo, presence: true

  mount_uploader :photo, PhotoUploader
  scope :unprocessed, where(state: :pending)


  def import_remote_photo!
    self.remote_photo_url = image_url_without_params
    self.photo?
  end

  def image_url_without_params
    uri = URI(url)
    uri.query = "" if uri.query.present?
    uri.to_s
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

end
