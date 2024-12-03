# frozen_string_literal: true

require "rails_helper"

RSpec.describe JWTEncoder do
  let(:expected_token) { "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.wGZQA1-lJKaOG-WFz3zQZdBlJ5I7Z2l9VoNxnmu0aRU" }

  describe "Methods" do
    it ".encode" do
      expect(described_class.encode({ user_id: 1 })).to eq(expected_token)
    end

    it ".decode" do
      expect(described_class.decode(expected_token)).to eq({ "user_id" => 1 })
    end
  end
end
