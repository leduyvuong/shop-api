source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.4'

gem 'rails', '~> 7.2.1'

gem 'pg', '>= 1.1', '< 2.0'
gem 'puma', '~> 6.4'
gem 'rack-attack'
gem 'rack-cors'
gem 'redis', '~> 5.0'
gem 'bootsnap', require: false

gem 'devise'
gem 'devise-jwt', '~> 0.12.0'
gem 'pundit'
gem 'active_model_serializers', '~> 0.10.0'
gem 'kaminari'
gem 'rswag-api'
gem 'rswag-ui'
gem 'rswag-specs'
gem 'aws-sdk-s3', require: false

group :development, :test do
  gem 'pry'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'database_cleaner-active_record'
end

group :test do
  gem 'simplecov', require: false
end

group :development do
  gem 'rubocop', require: false
  gem 'listen'
  gem 'spring'
end
