class AddArtistIdToCkeditorAssets < ActiveRecord::Migration
  if table_exists?(:ckeditor_assets)
    def change
      add_column :ckeditor_assets, :artist_id, :integer
      add_index  :ckeditor_assets, :artist_id
    end
  end
end
