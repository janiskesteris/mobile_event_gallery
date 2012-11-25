RSpec::Matchers.define :include_json_etags do |expected|
  match do |actual|
    etags = actual.map { |attributes| attributes["etag"] }
    etags.detect { |actual_etag| !expected.grep(/#{actual_etag}/).present? }
  end

  failure_message_for_should do |actual|
    "expected #{actual.map { |attributes| attributes["etag"] }.sort} to include json etags #{expected.sort}"
  end
end

RSpec::Matchers.define :eql_image_etags do |expected|
  match do |actual|
    actual.map(&:etag).sort == expected.sort
  end

  failure_message_for_should do |actual|
    "expected #{actual.map(&:etag).sort} to eql image etags #{expected.sort}"
  end
end