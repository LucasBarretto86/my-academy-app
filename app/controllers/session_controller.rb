# frozen_string_literal: true

class SessionController < ApplicationController
  def create
    if (user = User.authenticate_by(**session_params))
      session = resume_or_created_session_for(user)
      Current.user = user
      Current.session = session

      render json: { token: session.auth_token, session: SessionSerializer.new(session) }, status: :created
    else
      render json: { error: { message: "Email and/or Password invalid" } }, status: :unauthorized
    end
  end

  def destroy
    Current.clear_all
    render json: { message: "Session terminated!" }, status: :ok
  end

  private
    def session_params
      params.require(:session).permit(:email, :password)
    end

    def resume_or_created_session_for(user)
      session = user.sessions.find_or_initialize_by(auth_token: JWTEncoder.encode({ user_id: user.id }), ip_address: request.ip, user_agent: request.user_agent, expired: false)
      session.accessed_at = Time.current
      session.save!
      session
    end
end
