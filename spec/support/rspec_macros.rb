module RspecMacros
  def stub_correct_json_images_request
    stub_json_images_request(open(Rails.root.join('spec/fixtures/pending_images.json')).read)
  end

  def stub_invalid_json_images_request
    stub_json_images_request(open(Rails.root.join('spec/fixtures/invalid_pending_images.json')).read)
  end

  def stub_empty_json_images_request
    stub_json_images_request("")
  end

  def stub_incorrect_json_images_request
    stub_json_images_request("This is not a JSON response at all!")
  end


  def stub_json_images_request body
    stub_request(:get, PendingImage::Request::JSON_GALLERY_PATH).to_return(body: body)
  end
end

RSpec.configuration.include RspecMacros