# frozen_string_literal: true

require "rails_helper"

RSpec.describe API::V1::CoursesController, type: :request do
  let!(:user) { create(:user, :with_session) }
  let!(:course) { create(:course, :with_lessons, title: "My course", description: "My description") }

  before do
    authorize_user(user.id)
    create_list(:course, 10)
  end

  describe "GET #index" do
    it "returns list of courses" do
      get api_v1_courses_path

      expect(response).to have_http_status(:success)
      expect(response_body.count).to eq(11)
      expect(response_body[0]["title"]).to eq("My course")
      expect(response_body[0]["description"]).to eq("My description")
      expect(response_body[0]["description"]).to eq("My description")
      expect(response_body[0]["lessons_count"]).to eq(5)
      expect(response_body[0]).not_to have_key("lessons")
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get api_v1_course_path(course.id)

      expect(response).to have_http_status(:success)
      expect(response_body["title"]).to eq("My course")
      expect(response_body["description"]).to eq("My description")
      expect(response_body["lessons_count"]).to eq(5)
      expect(response_body).to have_key("lessons")
    end
  end

  describe "GET #create" do
    let(:valid_params) do
      { course:
        {
          title: "My new course",
          description: "My new course description",
          begins_at: Time.current.beginning_of_day,
          ends_at: Time.current.end_of_day
        }
      }
    end

    let(:invalid_params) do
      { course:
        {
          title: "",
          description: "",
          begins_at: nil,
          ends_at: nil
        }
      }
    end

    it "creates new course successfully" do
      expect { post api_v1_courses_path, params: valid_params }.to change(Course, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(response_body["title"]).to eq("My new course")
      expect(response_body["description"]).to eq("My new course description")
    end

    it "returns error if params are invalid" do
      subject = post api_v1_courses_path, params: invalid_params

      expect { subject }.to change(Course, :count).by(0)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response_body["errors"]).to eq({
        "begins_at" => ["can't be blank"],
        "description" => ["can't be blank"],
        "title" => ["can't be blank"]
      })
    end
  end

  describe "GET #update" do
    context "When course did not stared yet" do
      it "Update course title successfully" do
        put api_v1_course_path(course.id), params: { course: { title: "Updated course title" } }
        expect(response).to have_http_status(:ok)
        expect(response_body["title"]).to eq("Updated course title")
      end
    end

    context "When course was already started" do
      before do
        course.update_column(:begins_at, Time.current.beginning_of_day)
      end

      it "Update course title successfully" do
        put api_v1_course_path(course.id), params: { course: { title: "Updated course title" } }
        expect(response).to have_http_status(:unprocessable_content)
        expect(response_body["errors"]["title"]).to eq(["can't be changed after course begins"])
      end
    end
  end

  describe "GET #destroy" do
    context "When course did not stared yet" do
      it "removes course successfully" do
        expect { delete api_v1_course_path(course.id) }.to change(Course, :count).by(-1)
        expect(response).to have_http_status(:ok)
        expect(response_body["message"]).to eq("Course removed successfully")
      end
    end

    context "When course was already started" do
      before do
        course.update_column(:begins_at, Time.current.beginning_of_day)
      end

      it "cannot be destroyed" do
        expect { delete api_v1_course_path(course.id) }.to change(Course, :count).by(0)
        expect(response).to have_http_status(:unprocessable_content)
        expect(response_body["error"]).to eq("Course can not be destroyed after course begins")
      end
    end
  end
end
