require 'spec_helper'

describe PendingImage::Collection do
  let(:all_pending_images) { PendingImage::Builder.new(PendingImage::Request.new.parsed_json).images }
  before(:each) do
    stub_correct_json_images_request
  end

  describe "#filtered_images" do

    context "with no excluded messages" do
      subject { PendingImage::Collection.new(all_pending_images).filtered_images }
      it { should eql_image_etags(["etag1", "etag2", "etag3"]) }
    end

    context "with excluded images" do
      subject { PendingImage::Collection.new(all_pending_images, except_etags: ["etag1", "etag3"]).filtered_images }
      it { should eql_image_etags(["etag2"]) }
    end

  end

  describe "#each" do
    subject { PendingImage::Collection.new(all_pending_images) }
    it "should iterate through images" do
      subject.each do |image|
        all_pending_images.should include(image)
      end
    end
  end

  describe "#save!" do
    subject { Image.all }
    context "with valid images" do
      before(:each) do
        PendingImage::Collection.new(all_pending_images).save!
      end
      it { should eql_image_etags(["etag1", "etag2", "etag3"]) }
    end

    context "with invalid images" do
      before(:each) do
        stub_invalid_json_images_request
        PendingImage::Collection.new(all_pending_images).save!
      end
      it { should be_empty }
    end

  end

end
