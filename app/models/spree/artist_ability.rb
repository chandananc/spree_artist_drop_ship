module Spree
  class ArtistAbility
    include CanCan::Ability

    def initialize(user)
      user ||= Spree.user_class.new

      if user.artist
        # TODO: Want this to be inline like:
        # can [:admin, :read, :stock], Spree::Product, artists: { id: user.artist_id }
        # can [:admin, :read, :stock], Spree::Product, artist_ids: user.artist_id
        can [:admin, :read, :stock], Spree::Product do |product|
          product.artist_ids.include?(user.artist_id)
        end
        can [:admin, :index], Spree::Product
        can [:admin, :manage, :read, :ready, :ship], Spree::Shipment, order: { state: 'complete' }, stock_location: { artist_id: user.artist_id }
        can [:admin, :create, :update], :stock_items
        can [:admin, :manage], Spree::StockItem, stock_location_id: user.artist.stock_locations.pluck(:id)
        can [:admin, :manage], Spree::StockLocation, artist_id: user.artist_id
        can :create, Spree::StockLocation
        can [:admin, :manage], Spree::StockMovement, stock_item: { stock_location_id: user.artist.stock_locations.pluck(:id) }
        can :create, Spree::StockMovement
        can [:admin, :update], Spree::Artist, id: user.artist_id
      end

    end
  end
end