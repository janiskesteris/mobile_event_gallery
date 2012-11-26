Fabricator(:image) do
  uploaded_at { Time.now }
  etag { sequence(:etag) { |i| "57BC2F0850D7702#{i}" } }
  content_type "image/jpeg"
  url "http://fakeimage.com/image.jpg"
  state "pending"
  after_build { |image| image.import_remote_photo! }
end
