source 'https://rubygems.org'

ruby '2.2.3'

gem 'rails', '4.2.6'

# web server
gem 'puma', '~> 3.4'

gem 'mongo'
gem 'mongoid'

gem 'bootstrap-sass', '~> 3.3.6'
gem 'jquery-rails', '~> 4.1', '>= 4.1.1'
gem 'sass-rails', '~> 5.0', '>= 5.0.4'
gem 'turbolinks'
gem 'uglifier', '>= 1.3.0'
gem 'underscore-rails', '~> 1.8', '>= 1.8.3'
gem 'font-awesome-sass'

gem 'bcrypt', '~> 3.1.7'
gem 'figaro'
gem 'geocoder', '~> 1.3', '>= 1.3.1'
gem 'gmaps4rails', '~> 2.1', '>= 2.1.2'
gem 'mongoid-slug', '~> 5.2'
gem 'fog', require: 'fog/aws'
gem 'carrierwave-mongoid', '~> 0.8.1'
gem 'mini_magick', '~> 4.5', '>= 4.5.1'

# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0', group: :doc

group :production do
  gem 'rails_12factor', '~> 0.0.3'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.4', '>= 3.4.2'
  gem 'mongoid-rspec', '3.0.0'
  gem 'capybara', '~> 2.6', '>= 2.6.2'
  gem 'factory_girl_rails', '~> 4.6'
  gem 'faker'
  gem 'byebug'
  gem 'awesome_print'
end

group :test do
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'webmock'
end
