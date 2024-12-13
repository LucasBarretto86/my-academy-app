# frozen_string_literal: true

class API::V1::Courses::LessonsController < APIController
  before_action :resolve_admin_access!, only: [:create, :update, :destroy]
  before_action :set_course
  before_action :set_lesson, only: [:show, :update, :destroy]

  def index
    @lessons = @course.lessons
    render json: @lessons, each_serializer: LessonSerializer
  end

  def show
    render json: @lesson
  end

  def create
    @lesson = @course.lessons.create!(lesson_params)

    if @lesson.video.attached?
      VideoProcessingJob.perform_later(@lesson)
    end

    render json: @lesson, status: :created
  end

  def update
    @lesson.update!(lesson_params)
    render json: @lesson, status: :ok
  end

  def destroy
    @course.remove_and_rearrange_lessons!(@lesson)
    render json: { message: "Lesson removed and rearranged remaining lessons", course: CourseSerializer.new(@course.reload) }, status: :ok
  end

  private
    def set_course
      @course = Course.find(params[:course_id])
    end

    def set_lesson
      @lesson = @course.lessons.find(params[:id])
    end

    def lesson_params
      params.require(:lesson).permit(:title, :description, :number, :video, :thumbnail)
    end

    def resolve_admin_access!
      unless Current.user.admin?
        render json: { message: "Access denied! User doesn't have administrative role" }, status: :forbidden
      end
    end
end
