source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.6.0'

gem 'rails', '~> 5.2.3'

# backend and database
gem 'sqlite3'
gem 'active_model_serializers', '~> 0.10.0'
gem 'redis'

# auth
gem 'cancancan'
gem 'rolify'
gem 'signet'
gem 'rack-cors'

# other
gem 'google-api-client'

# development
gem 'irb', require: false
gem 'pry'
gem 'pry-byebug'
group :development, :test do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'annotate'
end

# deployment
gem 'puma'
gem 'dotenv-rails'
gem 'bootsnap', '>= 1.1.0', require: false
