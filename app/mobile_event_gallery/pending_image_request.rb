module PendingImage
  class Request
    JSON_GALLERY_PATH = "http://megimage.heroku.com/gallery"

    def parsed_json
      json.present? ? JSON.parse(json) : []
    end

    private

    def json
      uri = URI(JSON_GALLERY_PATH)
      Net::HTTP.get(uri)
    end

  end
end
