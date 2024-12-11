# frozen_string_literal: true

class CourseSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :begins_at, :ends_at, :lessons_count

  has_many :lessons, if: -> { instance_options[:include_lessons] }

  def lessons_count
    object.lessons.count
  end
end
