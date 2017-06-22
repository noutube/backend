source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.4'

# backend and database
gem 'sqlite3'
gem 'activeuuid', github: 'inbeom/activeuuid'
gem 'activeadmin'
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
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'ember-cli-rails'

# other
gem 'google-api-client'

# development
group :development, :test do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'rubocop'
  gem 'pry'
  gem 'pry-byebug'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'annotate'
end

# deployment
gem 'puma'
gem 'dotenv-rails'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
