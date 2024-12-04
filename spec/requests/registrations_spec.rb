# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationsController, type: :request do
  describe "POST /sign-up" do
    let(:valid_attributes) do
      {
        registration: {
          email: "test@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    let(:invalid_attributes) do
      {
        registration: {
          email: "test@example.com",
          password: "password123",
          password_confirmation: "wrong_password"
        }
      }
    end

    context "with valid parameters" do
      it "creates a new user" do
        expect { post "/sign-up", params: valid_attributes }.to change(User, :count).by(1)
      end

      it "returns a created status (201)" do
        post "/sign-up", params: valid_attributes
        expect(response).to have_http_status(:created)
      end

      it "returns the created user as JSON" do
        post "/sign-up", params: valid_attributes
        json_response = JSON.parse(response.body)
        expect(json_response["email"]).to eq("test@example.com")
      end
    end

    context "with invalid parameters" do
      it "does not create a new user" do
        expect { post "/sign-up", params: invalid_attributes }.not_to change(User, :count)
      end

      it "returns an unprocessable entity status (422)" do
        post "/sign-up", params: invalid_attributes, as: :json
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "returns error messages in the response" do
        post "/sign-up", params: invalid_attributes, as: :json
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]["password_confirmation"]).to include("doesn't match Password")
      end
    end
  end
end
