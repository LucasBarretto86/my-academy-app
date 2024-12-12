# frozen_string_literal: true

class Course::Lesson < ApplicationRecord
  belongs_to :course, inverse_of: :lessons

  has_one_attached :video
  has_one_attached :thumbnail

  validates :title, :description, presence: true
  validates :number, uniqueness: { scope: :course_id }

  validate :video_content_type
  validate :thumbnail_content_type

  before_create :set_lesson_number

  private
    def set_lesson_number
      self.number ||= (course.lessons.count + 1)
    end

    def video_content_type
      if video.attached? && !video.content_type.in?(%w[video/mp4 video/ogg video/webm])
        errors.add(:video, "only allows mp4, ogg or webm formats")
      end
    end

    def thumbnail_content_type
      if thumbnail.attached? && !thumbnail.content_type.in?(%w[image/jpeg image/jpg image/png image/webp])
        errors.add(:thumbnail, "only allows jpeg, jpg, png or webp formats")
      end
    end
end

# == Schema Information
#
# Table name: course_lessons
#
#  id          :integer          not null, primary key
#  description :text             default(""), not null
#  number      :integer          not null
#  title       :string           default(""), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  course_id   :integer          not null
#
# Indexes
#
#  index_course_lessons_on_course_id             (course_id)
#  index_course_lessons_on_course_id_and_number  (course_id,number) UNIQUE
#
# Foreign Keys
#
#  course_id  (course_id => courses.id)
#
