require 'factory_girl'
require 'ffaker'

FactoryGirl.define do
  factory :post do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraphs.join("\n\n") }
    sequence(:published_at) { |n| n.days.ago.utc }
    publish { rand(2) == 0 ? "true" : "false" }
    sequence(:created_at) { |n| n.hours.ago.utc }
    sequence(:updated_at) { |n| n.hours.ago.utc }
    user_id { rand(5) + 1 }
  end
end

for i in 0..255
  FactoryGirl.create(:post)
end
