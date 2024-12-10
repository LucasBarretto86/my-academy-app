# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    title { "My first Course" }
    description { "This is my first course example" }
    begins_at { Date.current.beginning_of_day }
    ends_at { Date.current.end_of_week.end_of_day }
  end
end
