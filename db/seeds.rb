require 'faker'

20.times do
  User.create!(email: Faker::Internet.email, password: "password")
end

User.create!(email: "tommchenry@gmail.com", password: "password")