# frozen_string_literal: true

require "rails_helper"

RSpec.describe API::V1::Courses::LessonsController, type: :request do
  let!(:user) { create(:user, :with_session) }
  let!(:course) { create(:course) }
  let!(:lesson_1) { create(:lesson, course: course, number: 1) }
  let!(:lesson_2) { create(:lesson, course: course, number: 2) }

  before { authorize_user(user.id) }

  describe "GET #index" do
    it "returns a list of lessons for the given course" do
      get api_v1_course_lessons_path(course), as: :json

      expect(response).to have_http_status(:success)
      expect(response_body.count).to eq(2)
      expect(response_body.first["id"]).to eq(lesson_1.id)
      expect(response_body.second["id"]).to eq(lesson_2.id)
    end

    it "returns an empty array if no lessons exist" do
      course_without_lessons = create(:course)
      get api_v1_course_lessons_path(course_without_lessons)

      expect(response).to have_http_status(:success)
      expect(response_body).to be_empty
    end
  end

  describe "GET #show" do
    it "returns a single lesson for the given course" do
      get api_v1_course_lesson_path(course, lesson_1)

      expect(response).to have_http_status(:success)
      expect(response_body["id"]).to eq(lesson_1.id)
      expect(response_body["title"]).to eq(lesson_1.title)
    end

    it "returns a 404 if the lesson does not exist" do
      non_existing_lesson_id = 999
      get api_v1_course_lesson_path(course, non_existing_lesson_id)

      expect(response).to have_http_status(:not_found)
      expect(response_body["error"]).to eq("Record not found")
    end
  end
end
