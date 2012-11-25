require 'spec_helper'

feature "As an authenticated Admin" do

  given(:signed_in_admin) { create_and_sign_in_admin }
  given(:pending_images) { [Fabricate.build(:image), Fabricate.build(:image), Fabricate.build(:image)] }

  background do
    PendingImage::Collection.any_instance.stub(:filtered_images) { pending_images }
  end

  scenario "I can see pending images" do
    visit new_admin_pending_image_path(admin_id: signed_in_admin)
    pending_images.each do |pending_image|
      page.should have_xpath("//img[contains(@src, '#{pending_image.url}')]")
    end
  end

end
