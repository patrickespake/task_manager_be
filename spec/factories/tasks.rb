# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    association :user
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    status { Task.statuses.keys.sample }
    due_date { Faker::Date.between(from: Date.today, to: 1.year.from_now) }
    priority { Task.priorities.keys.sample }
  end
end
