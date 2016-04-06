class StockLocationsBelongsToArtist < ActiveRecord::Migration
  def change
    add_column :spree_stock_locations, :artist_id, :integer
    add_index :spree_stock_locations, :artist_id
  end
end
