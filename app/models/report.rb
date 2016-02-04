class Report < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  belongs_to :requestor, class_name: "User"

  def parse_twitter
    user = client.user(self.name).to_hash
    self.has_default_image = user[:default_profile_image]
    self.total_tweets = user.[:statuses_count]
    self.followers_count = user[:followers_count]
    self.start_date = user[:created_at]

  end
end
