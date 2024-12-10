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
  end
end
