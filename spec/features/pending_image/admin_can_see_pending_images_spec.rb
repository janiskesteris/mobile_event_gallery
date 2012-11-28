require 'spec_helper'

feature "As an authenticated Admin" do

  given(:signed_in_admin) { create_and_sign_in_admin }
  given(:pending_images) { [Fabricate(:image), Fabricate(:image), Fabricate(:image)] }
  given(:processed_images) { [Fabricate(:image, state: "approved"), Fabricate(:image, state: "rejected")] }

  background do
    stub_empty_json_images_request
    visit new_admin_image_path(admin_id: signed_in_admin)
  end

  scenario "I can see pending images", js: true do
    pending_images
    click_link "Load new images"

    pending_images.each do |pending_image|
      should_have_image(pending_image.photo.list.url)
    end
  end

  scenario "I should not see processed images", js: true do
    processed_images
    click_link "Load new images"

    processed_images.each do |processed_image|
      should_not_have_image(processed_image.photo.list.url)
    end
  end

  scenario "I should see text if there are pending images", js: true do
    pending_images
    click_link "Load new images"

    page.should have_content("Newest unapproved images")
  end

end

feature "As an unauthenticated Admin" do
  given(:signed_in_admin) { create_and_sign_in_admin }

  background do
    Image.stub(:fetch_and_store_remote!) { [] }
  end

  scenario "I can visit pending image list page from home page" do
    visit root_path
    page.should_not have_content("Pending images")
    create_and_sign_in_admin
    visit root_path
    click_link "Pending images"
    page.should have_content("There are no new images")
  end

end
