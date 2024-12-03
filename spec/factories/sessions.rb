# frozen_string_literal: true

FactoryBot.define do
  factory :session do
    user_agent { "MyString" }
    ip_address { "MyString" }
    auth_token { "MyString" }
    tos { false }
    user { nil }
  end
end
