source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.6.0'

gem 'rails', '~> 6.0.2', '>= 6.0.2.1'

gem 'active_model_serializers', '~> 0.10.0'
gem 'cancancan'
gem 'google-api-client'
gem 'pg'
gem 'rack-cors'
gem 'redis', '~> 4.0'
gem 'signet'

# development
gem 'irb', require: false
gem 'pry'
gem 'pry-byebug'
group :development, :test do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop'
  gem 'rubocop-rails_config'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'annotate'
end

# deployment
gem 'puma', '~> 4.1'
gem 'dotenv-rails'
gem 'bootsnap', '>= 1.4.2', require: false
