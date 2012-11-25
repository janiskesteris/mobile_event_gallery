module ControllerMacros

  def create_and_sign_in_admin
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    admin = Fabricate(:admin) and sign_in(admin)
    admin
  end

end

RSpec.configuration.include ControllerMacros, :type => :controller