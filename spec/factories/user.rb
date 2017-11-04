FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    email {Faker::Internet.free_email}
    password Faker::Lorem.characters(10)
  end
end