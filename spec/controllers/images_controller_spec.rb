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

      it "should be able to access approved image list" do
        get :index
        response.response_code.should == 200
      end

      it "should be able to access approved image" do
        get :show, id: image
        response.response_code.should == 200
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

  describe "#index" do
    let(:image) { Fabricate :image, state: "approved" }
    before(:each) do
      @expected = [{
                       id: image.id,
                       uploaded_at: image.uploaded_at,
                       photo_url: image.photo_url
                   }].to_json
    end

    it "should respond to JSON request" do
      get :index, format: :json
      response.response_code.should == 200
      response.body.should == @expected
    end
  end

  describe "#update" do
    let(:admin) { create_and_sign_in_admin }

    it "should change images state" do
      put :update, admin_id: admin, id: image, image: {state: "approved"}, format: :js
      response.response_code.should == 200
      assigns[:image].state.should eql("approved")
      response.should render_template('update')
    end
  end

  describe "#destroy" do
    let(:admin) { create_and_sign_in_admin }

    it "should delete image record" do
      delete :destroy, admin_id: admin, id: image, format: :js
      response.response_code.should == 200
      assigns[:image].state.should eql("rejected")
      response.should render_template('destroy')
    end
  end

end
