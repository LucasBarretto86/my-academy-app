# frozen_string_literal: true

module Authorization
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  def authenticated?
    Current.session.present? && Current.session.token == Current.token
  end

  private
    def authenticate_user!
      unless authenticated?
        payload = JWTEncoder.decode(Current.token)

        if (session = Session.includes(:user).find_by(token: Current.token, user_id: payload["user_id"]))
          Current.session = session
          Current.user = session.user
        else
          Current.clear_all
          render json: { error: { message: "Unauthorized request" } }, status: :unauthorized
        end
      end
    end
end
