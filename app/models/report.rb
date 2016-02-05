class Report < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  belongs_to :requestor, class_name: "User"

  def parse_twitter

    profile_object = $client.user(self.name)
    profile = profile_object.to_hash
    follower_ids = $client.follower_ids(self.name).to_a
    friend_ids = $client.friend_ids(self.name).to_a
    newest_tweets = $client.user_timeline(name, {count: 200}).to_a

    self.follower_ids      = follower_ids
    self.profile_image_url = profile_object.profile_image_uri(size = :original).to_s
    self.description       = profile[:description]
    self.has_default_image = profile[:default_profile_image]
    self.total_tweets      = profile[:statuses_count]
    self.followers_count   = profile[:followers_count]
    self.start_date        = profile[:created_at]

    self.follower_friend_overlap_percent = followed_friends(follower_ids, friend_ids)
    self.repetition_percent = repetition(newest_tweets)
    self.faved_retweeted_percent = faved_retweeted(newest_tweets)
    self.score = self.tally
    self.save
  end

  def common_followers(user_handle)
    user_follower_ids = $client.follower_ids(user_handle).to_a
    target_follower_ids = self.follower_ids.map {|v| v.to_i}
    union = (target_follower_ids & user_follower_ids)
    union.length
  end

  def repetition(newest_tweets)
    text = newest_tweets.map(&:full_text)
    count = (newest_tweets.length > 0 ? newest_tweets.length : 1)
    return percentage(repeat_count(text).to_f / count)
  end

  def followed_friends(follower_ids, friend_ids)
    followed_friends = follower_ids & friend_ids
    follower_count = (follower_ids.count > 0 ? follower_ids.count : 1)
    percentage(followed_friends.length.to_f / follower_count)
  end

  def faved_retweeted(newest_tweets)
    faved_or_rtd_tweets = newest_tweets.reject do |tweet|
      tweet.favorite_count + tweet.retweet_count == 0
    end
    tweet_count = (newest_tweets.count > 0 ? newest_tweets.count : 1)
    percentage(faved_or_rtd_tweets.length.to_f / tweet_count)
  end

  def tally
    points = {}
    points[:image] = (self.has_default_image ? 0 : 10)
    points[:tweet_rate] = 10 - log_scale(self.tweets_per_day).to_i
    points[:follower_count] = log_scale(self.followers_count).to_i # 1,000 followers > ~10 pts, 2,000 > 10.9
    points[:age] = log_scale(self.age_days).to_i # 6 mos > 7.5 pts, 10 yrs > 11.8 pts
    points[:repetition] = 10 - (self.repetition_percent.to_f / 10).to_i
    points[:overlap] = (self.follower_friend_overlap_percent.to_f / 10).to_i
    points[:faved_retweeted] = (self.faved_retweeted_percent.to_f / 10).to_i
    points[:free] = 30
    # friends in common - 1 additional friends_list API call
    # association with baddies - 1 additional friends_list API call
    # usage of bad hash tags -
    points.values.reduce(:+)
  end

  def tweets_per_day
    self.total_tweets / (self.age_days > 0 ? self.age_days : 1)
  end

  def age_days
    (Date.today - self.start_date).numerator
  end

  def color
    return "" if !score
    if score >= 90
      return "green"
    elsif score >= 75
      return "yellow"
    else
      return "red"
    end
  end
end
