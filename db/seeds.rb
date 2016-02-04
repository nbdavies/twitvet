require 'faker'

20.times do
  User.create!(email: Faker::Internet.email, password: "password")
end

User.create!(email: "tommchenry@gmail.com", password: "password")

20.times do
  Report.create!(
    name: Faker::Internet.user_name,
    has_default_image: [true, false].sample,
    total_tweets: rand(0..1000),
    followers_count: rand(0..1000),
    start_date: Faker::Date.backward(5000),
    follower_friend_overlap_percent: rand(0..100),
    repetition_percent: rand(0..100),
    faved_retweeted_percent: rand(0..100)
    )
end
