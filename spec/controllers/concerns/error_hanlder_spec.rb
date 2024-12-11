# frozen_string_literal: true

require "rails_helper"

RSpec.describe ErrorHandler, type: :controller do
  controller(ApplicationController) do
    include ErrorHandler

    def test_error
    end
  end

  before { routes.draw { get "test_error" => "anonymous#test_error" } }

  subject { get :test_error }

  describe "Error handling" do
    it "handles ActiveRecord::RecordNotFound" do
      allow(controller).to receive(:test_error).and_raise(ActiveRecord::RecordNotFound)
      subject
      expect(response).to have_http_status(404)
      expect(response_body).to include("error" => "Record not found")
    end

    it "handles ActiveRecord::RecordInvalid" do
      record = build(:course, title: nil)
      record.valid?
      allow(controller).to receive(:test_error).and_raise(ActiveRecord::RecordInvalid.new(record))
      subject
      expect(response).to have_http_status(422)
      expect(response_body).to eq({ "errors" => { "title" => ["can't be blank"] } })
    end

    it "handles ActiveRecord::RecordNotDestroyed" do
      record = double("Course")
      allow(controller).to receive(:test_error).and_raise(ActiveRecord::RecordNotDestroyed.new("Record could not be destroyed", record))
      subject
      expect(response).to have_http_status(422)
      expect(response_body).to include("error" => "Record could not be destroyed")
    end

    it "handles StandardError" do
      allow(controller).to receive(:test_error).and_raise(StandardError, "Something went wrong")
      subject
      expect(response).to have_http_status(400)
      expect(response_body).to include("error" => "Something went wrong")
    end
  end
end
