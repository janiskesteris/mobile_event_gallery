require 'spec_helper'

feature "As an authenticated admin" do

  scenario "I can sign out" do
    create_and_sign_in_admin
    visit root_path
    click_link "Sign out"
    page.should have_css('.alert-success', :text => "Signed out successfully.")
  end

end