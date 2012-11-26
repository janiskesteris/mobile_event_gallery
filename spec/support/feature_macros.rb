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

end

RSpec.configuration.include FeatureMacros, :type => :feature