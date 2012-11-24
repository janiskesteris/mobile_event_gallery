require 'spec_helper'

feature "As an unauthenticated admin" do

  context "with valid admin credentials" do
    given(:admin) { Fabricate :admin }

    scenario "I can sign in" do
      real_sign_in admin.email, admin.password
      page.should have_css('.alert-success', :text => "Signed in successfully.")
    end
  end

  context "without valid credentials" do
    scenario "I should see validation errors" do
      real_sign_in "wrong_email@example.com", "wrong_password"
      page.should have_css('.alert-error', :text => "Invalid email or password.")
    end
  end
end