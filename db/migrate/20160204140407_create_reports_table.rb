class CreateReportsTable < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string  :name, null: false
      t.integer :requestor_id
      t.boolean :has_default_image
      t.integer :total_tweets
      t.date    :start_date
      t.integer :followers_count
      t.integer :repetition_percent
      t.integer :faved_retweeted_percent
      t.integer :follower_friend_overlap_percent
      t.integer :score
      t.timestamps
    end
  end
end
