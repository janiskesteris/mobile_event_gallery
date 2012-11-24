#Capybara.javascript_driver = :webkit

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers, :type => :feature
end