# frozen_string_literal: true

require "rails_helper"

RSpec.describe SessionController, type: :request do
  let!(:user) { create(:user, :with_session, email: "example@example.com", password: "password") }

  let(:valid_params) do
    {
      session: {
        email: user.email,
        password: user.password
      }
    }
  end

  let(:invalid_params) do
    {
      session: {
        email: "wrong@example.com",
        password: "wrong"
      }
    }
  end

  describe "POST /sign-in" do
    before do
      allow(Time).to receive(:current).and_return("2024-12-05T18:20:11.224Z".to_datetime)
    end

    it "returns http success" do
      post "/sign-in", params: valid_params
      expect(response).to have_http_status(:success)
      expect(response_body)
        .to include({
          "token" => "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.KjwaUY2Gvz2OQtN38olV8sUhhU4iJuMee9irBhilzic",
          "session" => {
            "logged_at" => "2024-12-05T18:20:11.224Z",
            "user" => {
              "full_name" => "Elizabeth Olsen",
              "email" => "example@example.com",
              "admin" => false
            }
          }
        })
    end

    it "returns unauthorized" do
      post "/sign-in", params: invalid_params
      expect(response).to have_http_status(:unauthorized)
      expect(response_body).to eq({ "error" => { "message" => "Email and/or Password invalid" } })
    end
  end

  describe "DELETE /sign-out" do
    before do
      Current.session = user.sessions.first
    end

    it "returns http success" do
      expect { delete "/sign-out" }.to change(Current, :session).to(nil)

      expect(response).to have_http_status(:success)
      expect(response_body).to eq({ "message" => "Session signed out!" })
    end
  end
end
