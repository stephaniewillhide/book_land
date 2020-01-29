source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{ repo }.git" }

ruby "2.6.1"

gem "rails", "~> 5.2.2", ">= 5.2.2.1"
gem "puma", "~> 3.12"
gem "coffee-rails", "~> 4.2"
gem "sass-rails", "~> 5.0"
gem "sqlite3", "~> 1.3.6"
gem "turbolinks", "~> 5"
gem "uglifier", ">= 1.3.0"
gem "kaminari"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

gem "bootstrap"
gem "devise"
gem "jquery-rails"
gem "simple_form"

group :development, :test do
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "byebug"
end

group :development do
  # Access an interactive console on exception pages or by calling "console" anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem "chromedriver-helper"
end
