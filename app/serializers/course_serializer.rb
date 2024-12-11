# frozen_string_literal: true

class CourseSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :begins_at, :ends_at
end
