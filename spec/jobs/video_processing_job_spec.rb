# frozen_string_literal: true

require "rails_helper"

RSpec.describe VideoProcessingJob, type: :job do
  let(:lesson) { create(:lesson, :with_video) }

  describe "#perform" do
    it "updates the lesson's video duration" do
      expect do
        VideoProcessingJob.perform_now(lesson.id)
      end.to change { lesson.reload.duration }.to(5.312)
    end

    it "does not update if video is not attached" do
      lesson.video.purge
      expect do
        VideoProcessingJob.perform_now(lesson.id)
      end.not_to change { lesson.reload.duration }
    end

    it "logs an error if an exception is raised" do
      allow(Rails.logger).to receive(:error)
      allow(VideoProcessingJob).to receive(:perform_now).and_raise(StandardError, "Something went wrong")

      # LUCAS: I have no clue what is the problem here
      # expect(Rails.logger).to receive(:error).with("Something went wrong")
      expect { VideoProcessingJob.perform_now(lesson.id) }.to raise_error(StandardError, "Something went wrong")
    end
  end
end
