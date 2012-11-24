require 'spec_helper'

describe Admin do

  it "should be valid when all fields are provided" do
    Fabricate.build(:admin).should be_valid
  end

  it "should not be valid if email is not provided" do
    Fabricate.build(:admin, email: "").should_not be_valid
  end

  it "should not be valid if password is not provided" do
    Fabricate.build(:admin, password: "").should_not be_valid
  end

  it "should not be valid if password_confirmation is not provided" do
    Fabricate.build(:admin, password_confirmation: "").should_not be_valid
  end

end
