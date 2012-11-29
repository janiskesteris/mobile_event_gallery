class Image < ActiveRecord::Base
  validates :etag, :content_type, :url, :photo, presence: true

  mount_uploader :photo, PhotoUploader
  scope :unprocessed, where(state: :pending)
  scope :approved, where(state: :approved)

  after_save do
    self.delay.update_twitter_if_approved if state == "approved" && !shared_on_twitter?
  end

  MAX_RETRY_COUNT_FOR_STATUS_UPDATE = 10


  def import_remote_photo!
    self.remote_photo_url = image_url_without_params
    self.photo?
  end

  def image_url_without_params
    uri = URI(url)
    uri.query = "" if uri.query.present?
    uri.to_s
  end

  def update_twitter_if_approved
    tries = 0
    begin
      Twitter.update_with_media("", File.new(photo.path))
    rescue Twitter::Error::Forbidden
      if tries < MAX_RETRY_COUNT_FOR_STATUS_UPDATE
        tries += 1
        retry
      end
    end
  end

  def photo_url
    Rails.configuration.domain+photo.url
  end

  def as_json(options={})
    {id: id, uploaded_at: uploaded_at, photo_url: photo_url}
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
