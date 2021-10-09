require 'modules/auth'

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private
      def find_verified_user
        payload = Auth.decode(request.params[:token])
        verified_user = User.find(payload['id'])
        raise unless verified_user
        verified_user
      rescue
        reject_unauthorized_connection
      end
  end
end
