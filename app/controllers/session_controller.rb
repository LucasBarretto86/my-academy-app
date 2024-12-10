# frozen_string_literal: true

class SessionController < ApplicationController
  def create
    if (user = User.authenticate_by(**session_params))
      session = find_or_created_session_for(user)

      Current.session = session
      Current.user = session.user

      render json: { token: session.token, session: SessionSerializer.new(session) }, status: :created
    else
      render json: { error: { message: "Email and/or Password invalid" } }, status: :unauthorized
    end
  end

  def destroy
    Current.clear_all
    render json: { message: "Session signed out!" }, status: :ok
  end

  private
    def session_params
      params.require(:session).permit(:email, :password)
    end

    def find_or_created_session_for(user)
      session = user.sessions.valid.find_or_initialize_by(token: JWTEncoder.encode({ user_id: user.id }))
      session.logged_at = Time.current
      session.expires_at = (Time.current + 1.day)
      session.save!
      session
    end
end
