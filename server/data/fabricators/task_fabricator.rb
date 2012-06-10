Fabricator(:task) do
  name { Faker::Lorem.sentence }
  public { rand(2) == 0 }
  created_at { sequence(:created, 1).hours.ago.utc }
  updated_at { sequence(:updated, 1).hours.ago.utc }
  user_id { rand(5) + 1 }
end
