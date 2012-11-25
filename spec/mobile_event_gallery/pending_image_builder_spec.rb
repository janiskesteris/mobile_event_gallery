require 'spec_helper'

describe PendingImage::Builder do
  let(:builder) { PendingImage::Builder.new(PendingImage::Request.new.parsed_json) }
  subject { builder.images }

  context "when successfully built" do
    before(:each) do
      stub_correct_json_images_request
    end
    its(:count) { should eql(3) }
    it { should eql_image_etags(["etag1", "etag2", "etag3"]) }
  end

  context "with empty JSON response" do
    before(:each) do
      stub_empty_json_images_request
    end
    it { should be_empty }
  end

  context "with invalid JSON provided" do
    before(:each) do
      stub_invalid_json_images_request
    end
    it { should be_empty }
  end
end