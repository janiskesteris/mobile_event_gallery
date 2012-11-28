module ImagesHelper
  def pending_image_list_title
    content_tag("h1", @pending_images.empty? ? "There are no new images" : "Newest unapproved images")
  end

  def approved_image_list_title
    content_tag("h1", @approved_images.empty? ? "No images here" : "Latest images")
  end
end
