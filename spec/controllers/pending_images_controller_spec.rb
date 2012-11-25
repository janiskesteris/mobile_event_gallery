require 'spec_helper'

describe PendingImagesController do

  describe Ability do
    context "when visiting as guest" do
      let(:admin) { Fabricate :admin }

      it "should not access pending image list" do
        get :new, admin_id: admin
        response.response_code.should == 401
      end
    end

    context "when visiting as Admin" do
      let(:admin) { create_and_sign_in_admin }

      it "should be able to access pending image list" do
        get :new, admin_id: admin
        response.response_code.should == 200
      end
    end
  end

end
