# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def create
    @user = User.create!(registration_params)
    render json: @user, status: :created
  end

  private
    def registration_params
      params.require(:registration).permit(:email, :password, :password_confirmation)
    end
end
