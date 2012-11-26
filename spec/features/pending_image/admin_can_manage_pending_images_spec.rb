require 'spec_helper'

feature "As an authenticated Admin" do

  given(:signed_in_admin) { create_and_sign_in_admin }
  given(:pending_images) { [Fabricate.build(:image), Fabricate.build(:image), Fabricate.build(:image)] }

  background do
    stub_empty_json_images_request
    PendingImage::Builder.any_instance.stub(:images) { pending_images }
    visit new_admin_image_path(admin_id: signed_in_admin)
  end

  scenario "I can approve pending images", js: true do
    pending_images.each do |pending_image|
      click_approve_button(pending_image)
      page.should have_content("Approved!")
    end
  end

  scenario "I can destroy pending images", js: true do
    pending_images.each do |pending_image|
      click_reject_button(pending_image)
      page.should have_content("Rejected!")
    end
  end

end
