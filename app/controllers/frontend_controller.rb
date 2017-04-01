class FrontendController < EmberCli::EmberController
  acts_as_token_authentication_handler_for User
end
