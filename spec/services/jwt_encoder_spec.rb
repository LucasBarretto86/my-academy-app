# frozen_string_literal: true

require "rails_helper"

RSpec.describe JWTEncoder do
  let(:expected_token) { "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.KjwaUY2Gvz2OQtN38olV8sUhhU4iJuMee9irBhilzic" }

  describe "Methods" do
    it ".encode" do
      expect(described_class.encode({ user_id: 1 })).to eq(expected_token)
    end

    it ".decode" do
      expect(described_class.decode(expected_token)).to eq({ "user_id" => 1 })
    end
  end
end
