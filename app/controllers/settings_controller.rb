class SettingsController < ApiController
  before_action :authenticate_user

  def show
    render json: current_user.settings
  end

  def update
    if current_user.update(settings: params[:setting])
      head :no_content
    else
      head :unprocessable_entity
    end
  end
end
