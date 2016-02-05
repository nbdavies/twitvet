class Report < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  belongs_to :requestor, class_name: "User"

  def parse_twitter
    profile = $client.user(self.name).to_hash
    follower_ids = $client.follower_ids(self.name).to_a
    friend_ids = $client.friend_ids(self.name).to_a
    newest_tweets = $client.user_timeline(name, {count: 200}).to_a

    self.has_default_image = profile[:default_profile_image]
    self.total_tweets      = profile[:statuses_count]
    self.followers_count   = profile[:followers_count]
    self.start_date        = profile[:created_at]

    self.follower_friend_overlap_percent = followed_friends(follower_ids, friend_ids)
    self.repetition_percent = repetition(newest_tweets)
    self.faved_retweeted_percent = faved_retweeted(newest_tweets)
    self.save
  end

  def repetition(newest_tweets)
    text = newest_tweets.map(&:full_text)
    count = newest_tweets.length
    return percentage(repeat_count(text).to_f / count)
  end

  def followed_friends(follower_ids, friend_ids)
    followed_friends = follower_ids & friend_ids
    percentage(followed_friends.length.to_f / follower_ids.count)
  end

  def faved_retweeted(newest_tweets)
    faved_or_rtd_tweets = newest_tweets.reject do |tweet|
      tweet.favorite_count + tweet.retweet_count == 0
    end
    percentage(faved_or_rtd_tweets.length.to_f / newest_tweets.length)
  end

  def tally
    points = {}
    points[:image] = (self.has_default_image ? 0 : 10)
    points[:tweet_rate] = 10 - Math.sqrt(self.tweets_per_day).to_i # 0 > 10 pts, 100 > 0 pts, 1000 > -21 pts (and you have an addiction)
    points[:follower_count] = Math.log2(self.followers_count).to_i # 1,000 followers > ~10 pts, 2,000 > 10.9
    points[:age] = Math.log2(self.age_days).to_i # 6 mos > 7.5 pts, 10 yrs > 11.8 pts
    points[:repetition] = 10 - (self.repetition_percent.to_f / 10).to_i
    points[:overlap] = (self.follower_friend_overlap_percent.to_f / 10).to_i
    points[:faved_retweeted] = (self.faved_retweeted_percent.to_f / 10).to_i
    points[:free] = 30
    # friends in common
    # association with baddies
    # usage of bad hash tags
    points.values.reduce(:+)
  end

  def tweets_per_day
    self.total_tweets / self.age_days
  end

  def age_days
    (Date.today - self.start_date).numerator
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

def percentage(ratio)
  (ratio * 100).to_i
end
