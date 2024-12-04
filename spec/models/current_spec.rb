# frozen_string_literal: true

require "rails_helper"

RSpec.describe Current, type: :model  do
  describe "attributes" do
    it "should have user attributes" do
      expect(described_class).to respond_to(:request_id, :user_agent, :ip_address, :user, :request, :session, :token)
    end
  end
end
