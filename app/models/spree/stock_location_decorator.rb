Spree::StockLocation.class_eval do

  belongs_to :artist, class_name: 'Spree::artist'

  scope :by_artist, -> (artist_id) { where(artist_id: artist_id) }

  # Wrapper for creating a new stock item respecting the backorderable config and artist
  durably_decorate :propagate_variant, mode: 'soft', sha: 'f35b0d8a811311d4886d53024a9aa34e3aa5f8cb' do |variant|
    if self.artist_id.blank? || variant.artists.pluck(:id).include?(self.artist_id)
      self.stock_items.create!(variant: variant, backorderable: self.backorderable_default)
    end
  end

  def available?(variant)
    stock_item(variant).try(:available?)
  end

end