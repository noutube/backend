class UsersController < ApiController
  acts_as_token_authentication_handler_for User, fallback: :exception

  def show
    authorize! :read, User
    user = if params[:id] == 'me'
             current_user
           else
             User.find(params[:id])
           end
    authorize! :read, user
    render json: current_user
  end

  def destroy
    authorize! :destroy, User
    user = User.find(params[:id])
    authorize! :destroy, user
    user.destroy!
    head :no_content
  end
end
