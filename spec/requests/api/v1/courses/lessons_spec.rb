# frozen_string_literal: true

require "rails_helper"

RSpec.describe API::V1::Courses::LessonsController, type: :request do
  let!(:user) { create(:user, :with_session) }
  let!(:course) { create(:course, :with_lessons) }
  let!(:lesson) { create(:lesson, course: course, title: "My lesson", number: nil) }

  before { authorize_user(user.id) }

  describe "GET #index" do
    before { create_list(:lesson, 5, course: course, number: nil) }

    it "returns a list of lessons for the given course" do
      get api_v1_course_lessons_path(course), as: :json

      expect(response).to have_http_status(:success)
      expect(response_body.count).to eq(11)
      expect(response_body).to include(lesson.slice(:id, :title, :description, :number, :course_id).as_json)
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
      get api_v1_course_lesson_path(course, lesson)

      expect(response).to have_http_status(:success)
      expect(response_body["id"]).to eq(lesson.id)
      expect(response_body["title"]).to eq(lesson.title)
    end

    it "returns a 404 if the lesson does not exist" do
      non_existing_lesson_id = 999
      get api_v1_course_lesson_path(course, non_existing_lesson_id)

      expect(response).to have_http_status(:not_found)
      expect(response_body["error"]).to eq("Record not found")
    end
  end

  describe "POST #create" do
    let(:valid_params) do
      {
        course_id: course.id,
        lesson: {
          title: "New lesson",
          description: "New lesson description"
        }
      }
    end

    let(:invalid_params) do
      {
        course_id: course.id,
        lesson: {
          title: "",
          description: "",
          number: 0
        }
      }
    end

    context "User is not admin" do
      it "returns 403 Forbidden" do
        expect { post api_v1_course_lessons_path(course_id: course.id, id: lesson.id), params: valid_params }.to change(Course::Lesson, :count).by(0)
        expect(response).to have_http_status(:forbidden)
        expect(response_body["message"]).to eq("Access denied! User doesn't have administrative role")
      end
    end

    context "User is admin" do
      before { user.update_column(:admin, true) }

      it "creates a new lesson" do
        expect { post api_v1_course_lessons_path(course_id: course.id), params: valid_params }.to change(Course::Lesson, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(response_body["title"]).to eq("New lesson")
        expect(response_body["description"]).to eq("New lesson description")
        expect(response_body["number"]).to eq(7)
      end

      it "return error if tries to create with invalid params" do
        expect { post api_v1_course_lessons_path(course_id: course.id), params: invalid_params }.to change(course.lessons, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body["errors"]).to eq({ "description" => ["can't be blank"], "title" => ["can't be blank"] })
      end
    end
  end

  describe "PUT #update" do
    context "User is not admin" do
      it "returns 403 Forbidden" do
        expect { put api_v1_course_lesson_path(course_id: course.id, id: lesson.id), params: { lesson: { title: "New updated title" } }, as: :json }.to change(Course::Lesson, :count).by(0)
        expect(response).to have_http_status(:forbidden)
        expect(response_body["message"]).to eq("Access denied! User doesn't have administrative role")
      end
    end

    context "User is admin" do
      before { user.update_column(:admin, true) }

      it "updates a course lesson" do
        put api_v1_course_lesson_path(course_id: course.id, id: lesson.id), params: { lesson: { title: "New updated title" } }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response_body["title"]).to eq("New updated title")
      end

      it "returns error if lesson update fails" do
        put api_v1_course_lesson_path(course_id: course.id, id: lesson.id), params: { lesson: { title: nil } }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response_body["errors"]).to eq({ "title" => ["can't be blank"] })
      end
    end
  end

  describe "DELETE #destroy" do
    context "User is not admin" do
      it "returns 403 Forbidden" do
        expect { delete api_v1_course_lesson_path(course_id: course.id, id: lesson.id) }.to change(Course::Lesson, :count).by(0)
        expect(response).to have_http_status(:forbidden)
        expect(response_body["message"]).to eq("Access denied! User doesn't have administrative role")
      end
    end

    context "User is admin" do
      before { user.update_column(:admin, true) }

      it "remove lessons and rearrange remaining lessons" do
        expect { delete api_v1_course_lesson_path(course_id: course.id, id: lesson.id) }.to change(Course::Lesson, :count).by(-1)
        expect(response).to have_http_status(:ok)
        expect(response_body["message"]).to eq("Lesson removed and rearranged remaining lessons")
        expect(response_body["course"]["lessons_count"]).to eq(5)
      end

      it "returns error if lesson fails to be deleted" do
        expect { delete api_v1_course_lesson_path(course_id: course.id, id: 999) }.to change(Course::Lesson, :count).by(0)

        expect(response).to have_http_status(:not_found)
        expect(response_body).to eq("error" => "Record not found")
      end
    end
  end
end
