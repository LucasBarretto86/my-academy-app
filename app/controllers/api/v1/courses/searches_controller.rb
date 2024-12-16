# frozen_string_literal: true

class API::V1::Courses::SearchesController < APIController
  def show
    @courses = Course.search(params[:query])
    render json: @courses, each_serializer: CourseSerializer
  end
end
