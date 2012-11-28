module FeatureMacros

  def real_sign_in email, password
    visit root_path
    click_link 'Sign in'
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Sign in"
  end

  def create_and_sign_in_admin
    admin = Fabricate(:admin)
    login_as(admin, :scope => :admin)
    admin
  end

  def click_approve_button image
    within "#image_block_#{image.id}" do
      click_button "Approve"
    end
  end

  def click_reject_button image
    within "#image_block_#{image.id}" do
      click_link "Reject"
    end
  end

  def should_have_image(image_path)
    page.should have_css("img[src='#{image_path}']")
  end

  def should_not_have_image(image_path)
    page.should_not have_css("img[src='#{image_path}']")
  end

  def click_image_link image_path
    find(:xpath, "//a/img[@src='#{image_path}']/..").click
  end

end

RSpec.configuration.include FeatureMacros, :type => :feature