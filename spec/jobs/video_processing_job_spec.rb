# frozen_string_literal: true

require "rails_helper"

RSpec.describe VideoProcessingJob, type: :job do
  let(:lesson) { create(:lesson, :with_video) }

  describe "#perform" do
    it "updates the lesson's video duration" do
      expect {
        VideoProcessingJob.perform_now(lesson.id)
      }.to change { lesson.reload.duration }.to(5.312)
    end

    it "does not update if video is not attached" do
      lesson.video.purge
      expect {
        VideoProcessingJob.perform_now(lesson.id)
      }.not_to change { lesson.reload.duration }
    end

    it "logs an error if an exception is raised" do
      allow(FFMPEG::Movie).to receive(:new).and_raise(StandardError, "Something went wrong")

      expect(Rails.logger).to receive(:error).with("Something went wrong")
      VideoProcessingJob.perform_now(lesson.id)
    end
  end
end
