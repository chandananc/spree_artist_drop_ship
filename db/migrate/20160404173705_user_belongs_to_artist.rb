class UserBelongsToArtist < ActiveRecord::Migration
  def change
    add_column Spree.user_class.table_name, :artist_id, :integer
    add_index Spree.user_class.table_name, :artist_id
  end
end
