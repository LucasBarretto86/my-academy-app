# frozen_string_literal: true

module Authorization
  extend ActiveSupport::Concern

  included do
    before_action :authorize_request!
  end

  def authenticated?
    Current.session.present? && Current.token == request.headers["Authorization"]&.split&.last
  end

  private
    def authorize_request!
      unless authenticated?
        Current.clear_all
        render json: { error: { message: "Unauthorized request" } }, status: :unauthorized
      end
    end
end