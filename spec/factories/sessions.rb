# frozen_string_literal: true

FactoryBot.define do
  factory :session do
    user_agent { Faker::Internet.user_agent }
    ip_address { Faker::Internet.ip_v4_address }
    expired { false }
    tos { true }

    before(:create) do |session|
      session.accessed_at = Time.current
    end
  end
end
