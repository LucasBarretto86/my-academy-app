# frozen_string_literal: true

require "rails_helper"

RSpec.describe Authorization, type: :controller do
  let!(:user) { create(:user, :with_session) }
  let!(:session) { user.sessions.first }
  let(:expected_token) { "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.KjwaUY2Gvz2OQtN38olV8sUhhU4iJuMee9irBhilzic" }

  controller(APIController) do
    include Authorization

    def test_action
      render plain: "OK"
    end
  end

  before { routes.draw { get "test_action" => "api#test_action" } }

  subject { get :test_action, as: :json }

  context "Callbacks" do
    context "before_action" do
      it "should trigger authenticate_user!" do
        expect(controller).to receive(:authenticate_user!).and_call_original
        subject
      end
    end
  end

  context "Methods" do
    describe "#authenticated?" do
      context "when user is authenticated" do
        before do
          allow(Current).to receive(:user).and_return(user)
          allow(Current).to receive(:session).and_return(user.sessions.first)
          allow(Current).to receive(:token).and_return(expected_token)
        end

        it "returns true if User is authenticated" do
          expect(controller.authenticated?).to be_truthy
        end
      end

      context "when user is not authenticated" do
        before do
          Current.user = nil
        end

        it "returns false if User is not authenticated" do
          expect(controller.authenticated?).to be_falsey
        end
      end
    end
  end
end
