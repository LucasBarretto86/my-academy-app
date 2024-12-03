# frozen_string_literal: true

require "rails_helper"

RSpec.describe SessionController, type: :request do
  let!(:user) { create(:user, email: "example@example.com", password: "password") }

  let(:valid_params) do
    {
      session: {
        email: "example@example.com",
        password: "password"
      }
    }
  end

  let(:invalid_params) do
    {
      session: {
        email: "example@example.com",
        password: "wrong"
      }
    }
  end

  describe "POST /sign-in" do
    it "returns http success" do
      post "/sign-in", params: valid_params
      expect(response).to have_http_status(:success)
    end

    it "returns unauthorized" do
      post "/sign-in", params: valid_params
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE /sign-out" do
    it "returns http success" do
      delete "/sign-out"
      expect(response).to have_http_status(:success)
    end
  end
end
