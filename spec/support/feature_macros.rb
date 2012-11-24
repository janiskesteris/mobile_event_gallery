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

end

RSpec.configuration.include FeatureMacros, :type => :feature