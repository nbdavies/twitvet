class AddProfileImageUrlAndBioColumns < ActiveRecord::Migration
  def change
    add_column  :reports, :profile_image_url, :string
    add_column  :reports, :description, :string
  end
end
