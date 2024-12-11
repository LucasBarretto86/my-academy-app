# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    title { Faker::Educator.course_name }
    description { Faker::Lorem.paragraph }
    begins_at { 1.day.from_now.beginning_of_day }
    ends_at { 1.day.from_now.end_of_week.end_of_day }

    trait :with_lessons do
      after(:build) do |course|
        create_list(:lesson, 5, course: course, number: nil)
      end
    end
  end
end
