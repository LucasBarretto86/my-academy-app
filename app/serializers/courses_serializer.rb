# frozen_string_literal: true

class CoursesSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :begins_at, :ends_at
end
