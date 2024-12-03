# frozen_string_literal: true

require "rails_helper"

RSpec.describe SessionController, type: :request do
  let!(:user) { create(:user, :with_session, email: "example@example.com", password: "password") }

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
      expect(response_body)
        .to include({
          "id" => 2,
          "user" => {
            "id" => 1,
            "name" => "Elizabeth",
            "surname" => "Olsen",
            "email" => "example@example.com",
            "admin" => false
          },
          "auth_token" => "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.cRSVkjWcS-38pQG8Ibuwy2ghh9Z6-Ohk5QdH0WkrLhk"
        })
    end

    it "returns unauthorized" do
      post "/sign-in", params: invalid_params
      expect(response).to have_http_status(:unauthorized)
      expect(response_body).to eq({ "error" => { "message" => "Unauthorized!" } })
    end
  end

  describe "DELETE /sign-out" do
    before do
      Current.session = user.sessions.first
    end

    it "returns http success" do
      expect { delete "/sign-out" }.to change(Current, :session).to(nil)

      expect(response).to have_http_status(:success)
      expect(response_body).to eq({ "message" => "Session terminated!" })
    end
  end
end
