class CreateArtists < ActiveRecord::Migration
  def change
    create_table :spree_artists do |t|
      t.boolean    :active, default: false, null: false
      t.references :address
      t.decimal    :commission_flat_rate, :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.float      :commission_percentage, default: 0.0, null: false
      t.string     :email
      t.string     :name
      t.string     :url
      t.string     :image
      t.datetime   :deleted_at
      t.timestamps
    end
    add_index :spree_artists, :address_id
    add_index :spree_artists, :deleted_at
    add_index :spree_artists, :active
  end
end
