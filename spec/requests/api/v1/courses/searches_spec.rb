# frozen_string_literal: true

require "rails_helper"

RSpec.describe API::V1::Courses::SearchesController, type: :request do
  let!(:user) { create(:user, :with_session) }
  let!(:courses) { create_list(:course, 5, :with_lessons) }
  let!(:course) { create(:course, :with_lessons) }

  before do
    Course.reindex
    authorize_user(user.id)
  end

  describe "GET #show" do
    it "returns http success" do
      get api_v1_course_search_path
      expect(response).to have_http_status(:success)
    end

    it "returns courses found on search" do
      get api_v1_course_search_path, params: { query: course.title }
      expect(response).to have_http_status(:success)
      expect(response_body.count).to eq(1)
      expect(response_body.first["title"]).to eq(course.title)
    end

    it "returns empty if no course can be found" do
      Course.destroy_all

      get api_v1_course_search_path, params: { query: "Some title" }
      expect(response).to have_http_status(:success)
      expect(response_body.count).to eq(0)
    end
  end
end
