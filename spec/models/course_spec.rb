# frozen_string_literal: true

require "rails_helper"

RSpec.describe Course, type: :model do
  describe "Associations" do
    it "has_many lessons" do
      association = described_class.reflect_on_association(:lessons)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:class_name]).to eq("Course::Lesson")
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

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

    context ".remove_and_rearrange_lessons!!" do
      let(:course) { create(:course, :with_lessons) }
      let(:destroying_lesson) { course.lessons.second }

      it "removes and rearranges remaining lessons" do
        expect { course.remove_and_rearrange_lessons!(destroying_lesson) }.to change { course.lessons.count }.by(-1)
      end

      it "rearranges remaining lessons" do
        expect(course.lessons.map(&:number)).to eq([1, 2, 3, 4, 5])

        course.remove_and_rearrange_lessons!(destroying_lesson)

        expect(course.lessons.reload.map(&:number)).to eq([1, 2, 3, 4])
      end

      it "removes unsaved message but doesnt effect" do
        unsaved_lesson = build(:lesson, course: course)
        expect { course.remove_and_rearrange_lessons!(unsaved_lesson) }.to change { course.lessons.count }.by(0)
      end

      it "removes but does not effect existing lessons if lesson is the last one" do
        last_lesson = course.lessons.last

        expect { course.remove_and_rearrange_lessons!(last_lesson) }.to change { course.lessons.map(&:number).count }.by(0)
      end
    end
  end
end
