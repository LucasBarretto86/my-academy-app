# frozen_string_literal: true

class Course::LessonSerializer < ActiveModel::Serializer
  attributes :id, :number, :title, :description

  belongs_to :course
end
