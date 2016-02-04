20.times do
  User.create!(email: Faker::Internet.email, password: "test")
end