require 'google/apis/oauth2_v2'
require 'signet/oauth_2/client'

class AuthController < ApplicationController
  rescue_from Signet::AuthorizationError do
    head :unauthorized
  end

  def new
    client = build_client \
      scope: ['email', 'https://www.googleapis.com/auth/youtube.readonly'],
      additional_parameters: {
        access_type: :offline,
        prompt: :consent
      }
    redirect_to client.authorization_uri.to_s
  end

  def callback
    # apparently the only way to render a view in API-only mode without breaking everything
    html = ActionController::Base.new.render_to_string \
      'auth/callback',
      locals: {
        name: 'login',
        data: params.slice(:code)
      }
      render html: html
  end

  def sign_in
    client = build_client \
      code: params[:code]
    client.fetch_access_token!

    oauth2 = Google::Apis::Oauth2V2::Oauth2Service.new
    oauth2.authorization = client
    userinfo = oauth2.get_userinfo_v2

    user = User.find_or_initialize_by(email: userinfo.email) do |user|
      user.authentication_token = SecureRandom.hex
    end
    user.refresh_token = client.refresh_token
    user.save!

    render json: user,
           serializer: UserAuthSerializer
  end

  private

  def build_client(**options)
    default_options = {
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://oauth2.googleapis.com/token',
      redirect_uri: auth_callback_url,
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET']
    }
    client = Signet::OAuth2::Client.new(default_options.merge(options))
  end
end
