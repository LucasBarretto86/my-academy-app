# frozen_string_literal: true

class LessonSerializer < ActiveModel::Serializer
  attributes :id, :number, :title, :description, :course_id, :thumbnail_url, :video_url

  def video_url
    return unless object.video.attached?

    @video_url ||= Rails.application.routes.url_helpers.rails_blob_path(object.video, only_path: true)
  end

  def thumbnail_url
    return unless object.thumbnail.attached?

    @thumbnail_url ||= Rails.application.routes.url_helpers.rails_blob_path(object.thumbnail, only_path: true)
  end
end
