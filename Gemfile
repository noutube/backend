source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.7.0'

gem 'rails', '~> 6.1.3', '>= 6.1.3.2'

gem 'active_model_serializers', '~> 0.10.0'
gem 'cancancan'
gem 'google-apis-oauth2_v2'
gem 'pg'
gem 'rack-cors'
gem 'redis'
gem 'signet'

# development
gem 'irb', require: false
gem 'pry'
gem 'pry-byebug'
group :development, :test do
  gem 'listen', '~> 3.3'
  gem 'rubocop'
  gem 'rubocop-rails_config'
  gem 'better_errors'
  gem 'annotate'
end

# deployment
gem 'puma', '~> 5.0'
gem 'dotenv-rails'
gem 'bootsnap', '>= 1.4.4', require: false
