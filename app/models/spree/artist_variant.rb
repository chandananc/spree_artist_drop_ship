module Spree
  class ArtistVariant < Spree::Base
    belongs_to :artist
    belongs_to :variant
  end
end