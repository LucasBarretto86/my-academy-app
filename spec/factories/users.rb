# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { "Elizabeth" }
    surname { "Olsen" }
    email { "elizabeth.olsen@gmail.com" }
    password { "password" }

    trait :with_session do
      after(:create) do |user|
        create(:session, user: user, auth_token: JWTEncoder.encode({ user_id: user.id }))
      end
    end
  end
end
