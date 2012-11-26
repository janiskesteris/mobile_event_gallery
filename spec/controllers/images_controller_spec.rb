require 'spec_helper'

describe ImagesController do
  let(:image) { Fabricate :image }
  before(:each) do
    stub_empty_json_images_request
  end

  describe Ability do
    context "when visiting as guest" do
      let(:admin) { Fabricate :admin }

      it "should not access pending image list" do
        get :new, admin_id: admin
        response.response_code.should == 401
      end

      it "should not access update action" do
        put :update, admin_id: admin, id: image
        response.response_code.should == 401
      end

      it "should not access update action" do
        delete :destroy, admin_id: admin, id: image
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

  describe "#update" do
    let(:admin) { create_and_sign_in_admin }

    it "should change images state" do
      put :update, admin_id: admin, id: image, image: {state: "approved"}, format: 'js'
      response.response_code.should == 200
      assigns[:image].state.should eql("approved")
      response.should render_template('update')
    end
  end

  describe "#destroy" do
    let(:admin) { create_and_sign_in_admin }

    it "should delete image record" do
      delete :destroy, admin_id: admin, id: image, format: 'js'
      response.response_code.should == 200
      assigns[:image].destroyed?.should be_true
      response.should render_template('destroy')
    end
  end

end
