require 'spec_helper'

describe PendingImage::Request do

  describe "#parsed_images" do
    subject { PendingImage::Request.new.parsed_json }

    context "with populated JSON request response" do
      before(:each) do
        stub_correct_json_images_request
      end

      it { should be_a(Array) }
      its(:count) { should eql(3) }
      it { should include_json_etags(["etag1", "etag2", "etag3"]) }
    end

    context "with empty JSON request response" do
      before(:each) do
        stub_empty_json_images_request
      end
      it { should be_empty }
    end

    context "with incorrect JSON request response" do
      before(:each) do
        stub_incorrect_json_images_request
      end
      it "should raise error" do
        expect { subject }.to raise_error(JSON::ParserError)
      end
    end

  end

end