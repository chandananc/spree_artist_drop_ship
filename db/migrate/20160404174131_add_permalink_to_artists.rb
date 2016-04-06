class AddPermalinkToArtists < ActiveRecord::Migration
  def change
    add_column :spree_artists, :slug, :string
    add_index :spree_artists, :slug, unique: true
  end
end
