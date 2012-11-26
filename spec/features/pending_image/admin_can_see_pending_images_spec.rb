require 'spec_helper'

feature "As an authenticated Admin" do

  given(:signed_in_admin) { create_and_sign_in_admin }
  given(:pending_images) { [Fabricate.build(:image), Fabricate.build(:image), Fabricate.build(:image)] }
  given(:processed_images) { [Fabricate.build(:image, state: "approved"), Fabricate.build(:image, state: "rejected")] }

  background do
    stub_empty_json_images_request
    PendingImage::Builder.any_instance.stub(:images) { pending_images }
  end

  scenario "I can visit pending image list page from home page" do
    visit root_path
    page.should_not have_content("Pending images")
    create_and_sign_in_admin
    visit root_path
    click_link "Pending images"
    page.should have_content("Newest unapproved images")
  end

  scenario "I can see pending images" do
    visit new_admin_pending_image_path(admin_id: signed_in_admin)
    pending_images.each do |pending_image|
      page.should have_xpath("//img[contains(@src, '#{pending_image.photo.list.url}')]")
    end
  end

  scenario "I should not see processed images" do
    visit new_admin_pending_image_path(admin_id: signed_in_admin)
    processed_images.each do |pending_image|
      page.should_not have_xpath("//img[contains(@src, '#{pending_image.photo.list.url}')]")
    end
  end

end
