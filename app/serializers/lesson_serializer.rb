# frozen_string_literal: true

class LessonSerializer < ActiveModel::Serializer
  attributes :id, :number, :title, :description, :course_id
end
