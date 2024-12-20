# frozen_string_literal: true

require "rails_helper"

RSpec.describe Course::Lesson, type: :model do
  describe "Associations" do
    it "belongs to a course" do
      association = described_class.reflect_on_association(:course)
      expect(association.macro).to eq(:belongs_to)
    end

    it "has_one_attached video" do
      expect(described_class.new.video).to be_an_instance_of(ActiveStorage::Attached::One)
    end

    it "has_one_attached thumbnail" do
      expect(described_class.new.thumbnail).to be_an_instance_of(ActiveStorage::Attached::One)
    end
  end

  describe "Validations" do
    it "validates mandatory attributes" do
      lesson = described_class.new

      expect(lesson).to be_invalid
      expect(lesson.errors.count).to eq(3)
      expect(lesson.errors[:course]).to eq(["must exist"])
      expect(lesson.errors[:title]).to eq(["can't be blank"])
      expect(lesson.errors[:description]).to eq(["can't be blank"])
    end

    it "validates lesson number uniqueness scoped by course" do
      lesson = create(:lesson, number: 1)
      new_lesson = lesson.dup

      expect(new_lesson).to be_invalid
      expect(new_lesson.errors.count).to eq(1)
      expect(new_lesson.errors[:number]).to eq(["has already been taken"])

      new_lesson.course = create(:course)
      expect(new_lesson).to be_valid
    end

    it "validates video content_type" do
      lesson = create(:lesson)
      lesson.video.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/sample.txt")),
        filename: "sample.txt",
        content_type: "text/plain"
      )
      expect(lesson).to be_invalid
      expect(lesson.errors.count).to eq(1)
      expect(lesson.errors[:video]).to eq(["only allows mp4, ogg or webm formats"])
    end

    it "validates thumbnail content_type" do
      lesson = create(:lesson)
      lesson.thumbnail.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/sample.txt")),
        filename: "sample.txt",
        content_type: "text/plain"
      )
      expect(lesson).to be_invalid
      expect(lesson.errors.count).to eq(1)
      expect(lesson.errors[:thumbnail]).to eq(["only allows jpeg, jpg, png or webp formats"])
    end
  end

  describe "Callbacks" do
    context "before_commit on create" do
      it "set_lesson_number" do
        lesson = build(:lesson, number: nil)

        expect { lesson.save! }.to change { lesson.number }.from(nil).to(1)
      end
    end
  end
end
