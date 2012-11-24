RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before :each  do
    DatabaseCleaner.strategy = if example.metadata[:js] || Capybara.current_driver != :rack_test
      :truncation
    else
      :transaction
    end
    DatabaseCleaner.start
  end

  config.after :each do  
    DatabaseCleaner.clean
  end  
end