class Report < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  belongs_to :requestor, class_name: "User"

  def parse_twitter
    user = $client.user(self.name).to_hash
    self.has_default_image = user[:default_profile_image]
    self.total_tweets = user[:statuses_count]
    self.followers_count = user[:followers_count]
    self.start_date = user[:created_at]
    follower_ids = $client.follower_ids(self.name).to_a
    friend_ids = $client.friend_ids(self.name).to_a
    self.follower_friend_overlap_percent = ((follower_ids & friend_ids).length / user[:friends_count] * 100).to_i
    last_200_tweets = $client.user_timeline(name, {count: 200}).to_a
    self.repetition_percent = (repeat_count(last_200_tweets.map(&:full_text)) / last_200_tweets.length * 100).to_i
    self.faved_retweeted_percent = ((last_200_tweets.reject{|tweet| tweet.favorite_count + tweet.retweet_count == 0}.length) / last_200_tweets.length * 100).to_i
    self.save
  end
end

def repeat_count(array)
  max = 0
  counts = Hash.new(0)
  array.each do |tweet|
    counts[tweet] += 1
    max = counts[tweet] if counts[tweet] > max
  end
  max - 1
end
