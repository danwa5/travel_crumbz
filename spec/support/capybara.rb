require 'capybara/rails'
# require 'rack_session_access/capybara'

Capybara.javascript_driver = :webkit

Capybara::Webkit.configure do |config|
  config.block_unknown_urls
end
