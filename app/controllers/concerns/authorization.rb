# frozen_string_literal: true

module Authorization
  extend ActiveSupport::Concern

  included do
    before_action :authorize_request!
  end

  def authenticated?
    debugger
    Current.session.present? && Current.session.auth_token == Current.token
  end

  private
    def authorize_request!
      unless authenticated?
        pp "WHY ARE YOU ARE NOT AUTHENTICATED?"
        Current.clear_all
        render json: { error: { message: "Unauthorized request" } }, status: :unauthorized
      end
    end
end
