Fabricator(:post) do
  title { Faker::Lorem.sentence }
  content { Faker::Lorem.paragraphs(rand(9) + 1).join("\n\n") }
  published_at { rand(2) == 0  ? sequence(:updated, 1).hours.ago.utc : nil }
  created_at { sequence(:created, 1).hours.ago.utc }
  updated_at { sequence(:updated, 1).hours.ago.utc }
  user_id { rand(5) + 1 }
end
