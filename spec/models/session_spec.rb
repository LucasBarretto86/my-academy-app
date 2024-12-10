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
      session = described_class.new

      expect(session).not_to be_valid
      expect(session.errors.count).to eq(4)
      expect(session.errors[:user]).to include("must exist")
      expect(session.errors[:token]).to include("can't be blank")
      expect(session.errors[:logged_at]).to include("can't be blank")
      expect(session.errors[:expires_at]).to include("can't be blank")
    end
  end

  describe "Scopes" do
    let(:user) { create :user }

    before do
      create_list(:session, 3, user: user, token: "token1")
      create_list(:session, 3, :expired, user: user, token: "token1")
    end

    it ".valid" do
      expect(Session.valid.count).to eq(3)
    end
  end
end
