# frozen_string_literal: true

require "streamio-ffmpeg"

class VideoProcessingJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: 5.seconds, attempts: 3

  def perform(lesson_id)
    lesson = Course::Lesson.find(lesson_id)
    return unless lesson.video.attached?

    video_path = ActiveStorage::Blob.service.path_for(lesson.video.key)
    video = FFMPEG::Movie.new(video_path)

    lesson.update!(duration: video.duration)
  rescue error
    Rails.logger.error("VideoProcessingJob failed: #{error.message}")
  end
end
