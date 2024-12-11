# frozen_string_literal: true

class API::V1::CoursesController < APIController
  before_action :set_course, only: [:show, :update, :destroy]

  def index
    @courses = Course.where.not("ends_at < ?", Time.current).order(begins_at: :asc)
    render json: @courses, each_serializer: CourseSerializer
  end

  def show
    render json: @course, serializer: CourseSerializer, include_lessons: true
  end

  def create
    @course = Course.create!(course_params)
    render json: @course, status: :created
  end

  def update
    @course.update!(course_params)
    render json: @course, status: :ok
  end

  def destroy
    @course.destroy!
    render json: { message: "Course removed successfully" }, status: :ok
  end

  private
    def course_params
      params.require(:course).permit(:title, :description, :begins_at, :ends_at)
    end

    def set_course
      @course = Course.find(params[:id])
    end
end
