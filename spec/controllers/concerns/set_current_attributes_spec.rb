# frozen_string_literal: true

require "rails_helper"

RSpec.describe SetCurrentAttributes, type: :controller do
  controller(ApplicationController) do
    include SetCurrentAttributes

    def test_action
      render plain: "OK"
    end
  end

  before { routes.draw { get "test_action" => "anonymous#test_action" } }

  describe "Setting Current attributes" do
    it "triggers set_current_attributes" do
      expect(controller).to receive(:set_current_attributes).and_call_original
      get :test_action
    end
  end
end
