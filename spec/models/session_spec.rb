# frozen_string_literal: true

require "rails_helper"

RSpec.describe Session, type: :model do
  describe "Associations" do
    it "belongs_to user" do
      macro = described_class.reflect_on_association(:user)
      expect(macro.macro).to eq(:belongs_to)
    end
  end

  describe "Validations" do
    it "validates mandatory attributes" do
      session = described_class.new(tos: nil, expired: nil)

      expect(session).not_to be_valid
      expect(session.errors[:user]).to include("must exist")
      expect(session.errors[:auth_token]).to include("can't be blank")
    end
  end
end
