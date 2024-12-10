# frozen_string_literal: true

FactoryBot.define do
  factory :session do
    user_agent { Faker::Internet.user_agent }
    ip_address { Faker::Internet.ip_v4_address }
    logged_at { Time.current }
    expires_at { Time.current + 1.day }

    trait :expired do
      logged_at { Time.current - 1.day }
      expires_at { Time.current - 1.hour }
    end
  end
end
