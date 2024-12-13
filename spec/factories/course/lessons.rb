# frozen_string_literal: true

FactoryBot.define do
  factory :lesson, class: "Course::Lesson" do
    number { 1 }
    title { Faker::Educator.subject }
    description { Faker::Lorem.paragraph }
    association :course

    trait :with_video do
      after(:build) do |lesson|
        lesson.video.attach(
          io: File.open(Rails.root.join("spec", "fixtures", "files", "sample.mp4")),
          filename: "sample.mp4",
          content_type: "video/mp4"
        )

        lesson.thumbnail.attach(
          io: File.open(Rails.root.join("spec", "fixtures", "files", "sample.webp")),
          filename: "thumbnail.mp4",
          content_type: "image/webp"
        )
      end
    end
  end
end
