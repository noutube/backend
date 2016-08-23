class WelcomeController < ApplicationController
  acts_as_token_authentication_handler_for User

  def index
    render nothing: true
  end
end
