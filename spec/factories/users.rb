# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { "Elizabeth" }
    surname { "Olsen" }
    email { "elizabeth.olsen@gmail.com" }
    password { "password" }
  end
end
