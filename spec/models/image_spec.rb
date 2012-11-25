require 'spec_helper'

describe Image do
  context "with valid attributes" do
    subject { Fabricate :image }
    its(:new_record?) { should be_false }
  end
  context "with invalid attributes" do
    subject { Fabricate.build :image, etag: "", content_type: "", photo: "" }
    its(:valid?) { should be_false }
  end

  context "with unsanitized attributes" do
    let(:time_now) { Time.parse("Sun, 25 Nov 2012 12:14:32 UTC +00:00") }
    subject { Fabricate :image, uploaded_at: "\'#{time_now.to_s}\'", etag: "\"etag\"", content_type: "\"content_type\"" }

    its(:uploaded_at) { should eql(time_now) }
    its(:etag) { should eql("etag") }
    its(:content_type) { should eql("content_type") }
  end


end
