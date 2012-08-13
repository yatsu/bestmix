FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    password "password"
    password_confirmation "password"
  end

  factory :post do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraphs }
    sequence(:published_at) { |n| n.days.ago }
    publish "true"
    user

    factory :non_published_post do
      published_at nil
      publish "false"
    end

    factory :deleted_post do
      sequence(:deleted_at) { |n| n.hours.ago }
    end
  end
end
