# frozen_string_literal: true

class Course < ApplicationRecord
  searchkick

  has_many :lessons, -> { order(number: :asc) }, class_name: "Course::Lesson", dependent: :destroy

  validates :title, :description, :begins_at, presence: true

  validate :restricted_attribute_changes, on: [:update]

  def started?
    begins_at < Time.current
  end

  def destroy!
    if started?
      raise ActiveRecord::RecordNotDestroyed.new("Course can not be destroyed after course begins", self)
    else
      super
    end
  end

  def remove_and_rearrange_lessons!(destroying_lesson)
    transaction do
      if destroying_lesson.destroy!
        lessons.order(:number).each_with_index do |lesson, index|
          lesson.update_column(:number, index + 1)
        end
      else
        raise ActiveRecord::Rollback, "Failed to remove lesson"
      end
    end
  end

  private
    def restricted_attribute_changes
      if started? || begins_at_was < Time.current
        restricted_attributes = changed_attribute_names_to_save & %w[title description begins_at]

        restricted_attributes.each do |attr|
          errors.add(attr.to_sym, "can't be changed after course begins")
        end
      end
    end
end

# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  begins_at   :datetime         not null
#  description :text             default(""), not null
#  ends_at     :datetime
#  title       :string           default(""), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
