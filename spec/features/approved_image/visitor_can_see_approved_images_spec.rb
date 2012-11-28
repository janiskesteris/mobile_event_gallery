require 'spec_helper'

feature "As a Visitor" do

  given(:approved_images) { [Fabricate(:image, state: "approved"), Fabricate(:image, state: "approved"), Fabricate(:image, state: "approved")] }

  background do
    approved_images
    visit images_path
  end

  scenario "I can see a list of approved images" do
    approved_images.each do |approved_image|
      should_have_image(approved_image.photo.list.url)
    end
  end

  scenario "I can see single image view" do
    one_image = approved_images.last
    click_image_link(one_image.photo.list.url)
    should_have_image(one_image.photo.url)
  end


end
