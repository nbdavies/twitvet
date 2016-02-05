class AddFollowersColumn < ActiveRecord::Migration
  def change
    add_column  :reports, :follower_ids, :string, array: true, default: []
  end
end
