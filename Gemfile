source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.7.0'

gem 'rails', '~> 6.1.4.1'

gem 'active_model_serializers', '~> 0.10.0'
gem 'activerecord-pg_enum'
gem 'bcrypt'
gem 'cancancan'
gem 'enum_attributes_validation'
gem 'jwt'
gem 'pg'
gem 'rack-cors'
gem 'redis'

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
