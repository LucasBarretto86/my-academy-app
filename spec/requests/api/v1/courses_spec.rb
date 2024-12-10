# frozen_string_literal: true

require "rails_helper"

RSpec.describe API::V1::CoursesController, type: :request do
  let!(:user) { create(:user, :with_session) }

  before do
    authorize_user(user.id)
  end

  describe "GET #index" do
    it "returns http success" do
      get "/api/v1/courses"
      pp response.headers
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get "/api/v1/courses/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #create" do
    it "returns http success" do
      get "/api/v1/courses/create"
      expect(response).to have_http_status(:created)
    end
  end

  describe "GET #update" do
    it "returns http success" do
      get "/api/v1/courses/update"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #destroy" do
    it "returns http success" do
      get "/api/v1/courses/destroy"
      expect(response).to have_http_status(:success)
    end
  end
end
