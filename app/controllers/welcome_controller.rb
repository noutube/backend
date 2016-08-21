require 'google/apis/youtube_v3'

class WelcomeController < ApplicationController
  acts_as_token_authentication_handler_for User

  def index
    render nothing: true
  end
end
