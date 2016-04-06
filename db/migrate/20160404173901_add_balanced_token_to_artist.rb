class AddBalancedTokenToArtist < ActiveRecord::Migration
  def change
    add_column :spree_artists, :tax_id, :string
    add_column :spree_artists, :token, :string
    add_index :spree_artists, :token
  end
end
