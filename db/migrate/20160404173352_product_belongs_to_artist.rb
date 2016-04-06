class ProductBelongsToArtist < ActiveRecord::Migration
  def change
    add_column :spree_products, :artist_id, :integer
    add_index :spree_products, :artist_id
  end
end
