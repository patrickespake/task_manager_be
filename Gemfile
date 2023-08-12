# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'bootsnap', require: false
gem 'devise'
gem 'doorkeeper'
gem 'jsonapi-serializer'
gem 'kaminari'
gem 'paper_trail'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rack-cors'
gem 'rails', '~> 7.0.7'
gem 'rails-i18n'
gem 'rswag-api'
gem 'rswag-ui'
gem 'rubocop-rails', require: false
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rswag-specs'
  gem 'simplecov', require: false
end

group :development do
  gem 'spring'
  gem 'web-console'
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers', require: false
end
