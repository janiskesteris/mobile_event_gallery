Fabricator(:image) do
  uploaded_at { Time.now }
  etag { sequence(:etag) { |i| "57BC2F0850D7702#{i}" } }
  content_type "image/jpeg"
  url "path/to/photo.jpg"
end
