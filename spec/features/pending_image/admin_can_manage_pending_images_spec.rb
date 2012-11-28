require 'spec_helper'

feature "As an authenticated Admin" do

  given(:signed_in_admin) { create_and_sign_in_admin }
  given(:pending_images) { [Fabricate(:image), Fabricate(:image), Fabricate(:image)] }

  background do
    stub_empty_json_images_request
    visit new_admin_image_path(admin_id: signed_in_admin)
    pending_images
    click_link "Load new images"
  end

  scenario "I can approve pending images", js: true do
    pending_images.each do |pending_image|
      click_approve_button(pending_image)
      page.should have_content("Approved!")
    end
  end

  scenario "I can reject pending images", js: true do
    pending_images.each do |pending_image|
      click_reject_button(pending_image)
      page.should have_content("Rejected!")
    end
  end

end
