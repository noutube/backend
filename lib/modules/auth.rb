require 'signet/oauth_2/client'

module Auth
  DEFAULT_OPTIONS = {
    authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
    token_credential_uri: 'https://oauth2.googleapis.com/token',
    client_id: ENV['GOOGLE_CLIENT_ID'],
    client_secret: ENV['GOOGLE_CLIENT_SECRET']
  }.freeze

  class << self
    def build_client(**options)
      Signet::OAuth2::Client.new(DEFAULT_OPTIONS.merge(options))
    end
  end
end
