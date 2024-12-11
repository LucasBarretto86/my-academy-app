# frozen_string_literal: true

class API::V1::Courses::LessonsController < APIController
  before_action :set_course

  def index
    @lessons = @course.lessons
    render json: @lessons, each_serializer: Course::LessonSerializer
  end

  def show
    @lesson = @course.lessons.find(params[:id])
    render json: @lesson, serializer: Course::LessonSerializer
  end

  private
    def set_course
      @course = Course.find(params[:course_id])
    end
end
