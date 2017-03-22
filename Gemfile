source 'https://rubygems.org'

gem 'rails', '~> 4.2'

# backend and database
gem 'sqlite3'
gem 'activeuuid'
#gem 'pg'
gem 'activeadmin', github: 'activeadmin'
gem 'active_model_serializers', '~> 0.10.0'

# auth
gem 'devise'
gem 'simple_token_authentication'
gem 'cancancan'
gem 'rolify'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'signet'

# frontend and assets
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
#gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'turbolinks'
gem 'ember-cli-rails'

# other
gem 'google-api-client'

# development
group :development, :test do
  gem 'pry'
  gem 'pry-byebug'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'annotate', github: 'ctran/annotate_models'
  gem 'thin'
end

group :production do
  # deployment
  #gem 'unicorn'
  #gem 'foreman'
  #gem 'capistrano-rails', group: :development
  #gem 'rails_12factor', group: :production
end
