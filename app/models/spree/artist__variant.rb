module Spree
  class ArtistVariant < Spree::Base
    belongs_to :supplier
    belongs_to :variant
  end
end