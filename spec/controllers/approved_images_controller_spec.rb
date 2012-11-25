require 'spec_helper'

describe ApprovedImagesController do
  describe Ability do
    context "when visiting as guest" do
      it "should access approved album index page" do
        get :index
        response.response_code.should == 200
      end
    end
  end
end
