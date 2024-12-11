# frozen_string_literal: true

FactoryBot.define do
  factory :lesson, class: "Course::Lesson" do
    number { 1 }
    title { Faker::Educator.subject }
    description { Faker::Lorem.paragraph }
    association :course
  end
end
