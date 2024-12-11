# frozen_string_literal: true

require "rails_helper"

RSpec.describe Course, type: :model do
  describe "Validations" do
    it "validates mandatory attributes" do
      course = described_class.new

      expect(course).not_to be_valid
      expect(course.errors.count).to eq(3)
      expect(course.errors[:title]).to eq(["can't be blank"])
      expect(course.errors[:description]).to eq(["can't be blank"])
      expect(course.errors[:begins_at]).to eq(["can't be blank"])
    end

    it "validates that restricted attributes cannot be changed after course started" do
      course = create(:course, begins_at: 1.day.ago)
      course.update(title: "New Title", description: "New Description", begins_at: 1.day.from_now)

      expect(course).not_to be_valid
      expect(course.errors[:title]).to eq(["can't be changed after course begins"])
      expect(course.errors[:description]).to eq(["can't be changed after course begins"])
      expect(course.errors[:begins_at]).to eq(["can't be changed after course begins"])
    end
  end

  describe "Methods" do
    it ".started?" do
      course = create(:course)
      expect(course.started?).to be_falsey

      course.begins_at = Time.current.beginning_of_day
      expect(course.started?).to be_truthy
    end

    context ".destroy!" do
      it "destroys course if it has not started yes" do
        course = create(:course)
        expect { course.destroy! }.to change(Course, :count).by(-1)
      end

      it "does not destroy course if it has already started" do
        course = create(:course, begins_at: 1.day.ago)
        expect { course.destroy! }.to raise_error(ActiveRecord::RecordNotDestroyed)
      end
    end
  end
end
