require 'spec_helper'

feature "As an authenticated Admin" do

  given(:signed_in_admin) { create_and_sign_in_admin }

  scenario "I can approve pending images"
  scenario "I can destroy pending images"

end
