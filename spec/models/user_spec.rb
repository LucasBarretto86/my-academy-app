# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "Validations" do
    it "validates mandatory attributes" do
      user = described_class.new
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
      expect(user.errors[:password]).to include("can't be blank")
    end

    it "validates password min length" do
      user = build(:user, password: "123")
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("must be at least 8 characters")
    end

    it "validates that user responds to admin?" do
      user = build(:user, admin: true)
      expect(user.admin?).to be_truthy
    end
  end
end
