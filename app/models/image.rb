class Image < ActiveRecord::Base
  SANITIZE_REGEXP = /(\"|\')/
  validates :etag, :content_type, :url, presence: true

  before_validation :sanitize_attributes


  private

  def sanitize_attributes
    [:etag, :content_type, :url].each do |sanitizeable_attribute|
      value = self.send(sanitizeable_attribute)
      self.send("#{sanitizeable_attribute}=", value.gsub(SANITIZE_REGEXP, "")) if value
    end
  end
end
