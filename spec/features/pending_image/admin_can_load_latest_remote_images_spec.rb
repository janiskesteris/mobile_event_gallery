require 'spec_helper'

feature "As an authenticated Admin a want to download images from remote server" do

  given(:signed_in_admin) { create_and_sign_in_admin }
  given(:pending_images) { [Fabricate.build(:image), Fabricate.build(:image), Fabricate.build(:image)] }

  background do
    stub_empty_json_images_request
    PendingImage::Builder.any_instance.stub(:images) { pending_images }
    visit new_admin_image_path(admin_id: signed_in_admin)
  end

  scenario "get remote images", js: true do

  end


end
