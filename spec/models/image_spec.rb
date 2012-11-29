require 'spec_helper'

describe Image do
  context "with valid attributes" do
    subject { Fabricate :image }
    its(:new_record?) { should be_false }
  end

  describe "#after_initialize" do
    context "with invalid attributes" do
      subject { Fabricate.build :image, etag: "", content_type: "", photo: "" }
      its(:valid?) { should be_false }
    end

    context "with saved image object" do
      let(:modified_image) do
        image = Fabricate :image
        image.update_attribute(:etag, "\"etag\"")
        image
      end
      subject { modified_image.reload }
      its(:etag) { should eql("\"etag\"") }
    end
  end

  describe "#import_remote_photo!" do
    let(:image) { Fabricate.build(:image, url: "http://fakeurl.com/image.jpg", photo: nil) }
    subject { image.import_remote_photo! }

    context "with normal existing image" do
      before(:each) do
        stub_request(:get, "http://fakeurl.com/image.jpg").to_return(body: open(Rails.root.join('spec/fixtures/test.jpg')).read)
      end
      it { should be_true }
    end

    context "with existing image that has no file extension" do
      before(:each) do
        stub_request(:get, "http://fakeurl.com/image.jpg").to_return(body: open(Rails.root.join('spec/fixtures/test')).read)
      end
      it { should be_true }
    end

    context "with non existing image url" do
      subject { Fabricate.build(:image, url: "sdadasdasd").import_remote_photo! }
      it { should be_false }
    end

  end

  describe "#existing_image_etags" do
    subject { Image.existing_image_etags }
    before(:each) do
      stub_correct_json_images_request
      Fabricate(:image, etag: "etag1")
      Fabricate(:image, etag: "etag2")
    end

    it { should eql(["etag1", "etag2"]) }
  end

  describe "#fetch_and_store_remote" do
    subject { Image.fetch_and_store_remote! }
    before(:each) do
      stub_correct_json_images_request
    end

    context "with valid remote images" do
      it { should eql_image_etags(["etag1", "etag2", "etag3"]) }
    end

    context "with invalid remote images" do
      before(:each) do
        stub_invalid_json_images_request
      end
      it { should be_empty }
    end

    context "when called multiple times" do
      let(:first_call!) { Image.fetch_and_store_remote! }
      let(:second_call!) { Image.fetch_and_store_remote! }
      it "should not create duplicates" do
        first_call!
        Image.count.should eql(3)
        second_call!
        Image.count.should eql(3)
      end
    end

  end

  describe "#unprocessed" do
    subject { Image.unprocessed }
    let(:pending_image) { Fabricate(:image, state: "pending") }
    before(:each) do
      Fabricate(:image, state: "approved")
      Fabricate(:image, state: "rejected")
      pending_image
    end

    its(:all) { should eql([pending_image]) }
  end

  describe "#image_url_without_params" do
    context "with no query params" do
      subject { Fabricate(:image, url: "http://fakeimage.com/image.jpg").image_url_without_params }
      it { should eql("http://fakeimage.com/image.jpg") }
    end

    context "with query params" do
      subject { Fabricate(:image, url: "http://fakeimage.com/image.jpg?param1=2&param2=1").image_url_without_params }
      it { should eql("http://fakeimage.com/image.jpg?") }
    end
  end

  describe "#after save" do
    subject { Fabricate :image, shared_on_twitter: false }
    before(:each) do
      PhotoUploader.any_instance.stub(:path) { File.new(Rails.root.join('spec/fixtures/test.jpg')) }
    end

    context "with approved state and image not shared on twitter" do
      it "should update twitter status" do
        Twitter.should_receive(:update_with_media).with("", kind_of(File)).once
        subject.state = "approved"
        subject.save
      end
    end

    context "with rejected state and not shared on twitter " do
      it "should not update twitter status when rejected" do
        Twitter.should_not_receive(:update_with_media).with("", kind_of(File))
        subject.update_attributes(state: "rejected")
      end
    end

    context "when already been shared on twitter " do
      subject { Fabricate :image, shared_on_twitter: true }

      it "should not update twitter status when rejected" do
        Twitter.should_not_receive(:update_with_media).with("", kind_of(File))
        subject.update_attributes(state: "approved")
      end
    end

    context "when failing with error Twitter::Error::Forbidden" do
      before(:each) do
        Twitter.stub(:update_with_media) { raise Twitter::Error::Forbidden }
      end

      it "should retry update_with_media" do
        Twitter.should_receive(:update_with_media).exactly(11).times
        subject.update_attributes(state: "approved")
      end

    end

  end

end
