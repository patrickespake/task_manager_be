# frozen_string_literal: true

FactoryBot.define do
  factory :application, class: 'Doorkeeper::Application' do
    sequence(:name) { |n| "Project #{n}" }
  end
end
