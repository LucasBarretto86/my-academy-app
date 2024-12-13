# frozen_string_literal: true

require "streamio-ffmpeg"

class VideoProcessingJob < ApplicationJob
  queue_as :default

  def perform(lesson_id)
    lesson = Course::Lesson.find(lesson_id)
    return unless lesson.video.attached?

    video_path = ActiveStorage::Blob.service.path_for(lesson.video.key)
    video = FFMPEG::Movie.new(video_path)

    lesson.update!(duration: video.duration)
  rescue StandardError => error
    Rails.logger.error(error.message)
  end
end
