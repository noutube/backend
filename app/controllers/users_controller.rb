class UsersController < ApiController
  acts_as_token_authentication_handler_for User, fallback: :exception

  def show
    user = if params[:id] == 'me'
             current_user
           else
             User.find(params[:id])
           end

    if user.id == current_user.id
      render json: current_user
    else
      head :forbidden
    end
  end

  def destroy
    user = User.find(params[:id])

    if user.id == current_user.id
      user.destroy!
      head :no_content
    else
      head :forbidden
    end
  end
end
