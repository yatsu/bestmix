Fabricator(:post) do
  title { Faker::Lorem.sentence }
  content { Faker::Lorem.paragraphs(rand(9) + 1).join("\n\n") }
  publish { rand(2) == 0 ? "true" : "false" }
  created_at { sequence(:created, 1).hours.ago.utc }
  updated_at { sequence(:updated, 1).hours.ago.utc }
  user_id { rand(5) + 1 }
end
