require 'spec_helper'
require 'cancan/matchers'
require 'spree/testing_support/ability_helpers'

describe Spree::ArtistAbility do

  let(:user) { create(:user, artist: create(:artist)) }
  let(:ability) { Spree::ArtistAbility.new(user) }
  let(:token) { nil }

  context 'for Dash' do
    let(:resource) { Spree::Admin::RootController }

    context 'requested by artist' do
      it_should_behave_like 'access denied'
      it_should_behave_like 'no index allowed'
      it_should_behave_like 'admin denied'
    end
  end

  context 'for Product' do
    let(:resource) { create(:product) }

    it_should_behave_like 'index allowed'
    it_should_behave_like 'admin granted'

    context 'requested by another artists user' do
      let(:resource) {
        product = create(:product)
        product.add_artist!(create(:artist))
        product
      }
      it_should_behave_like 'access denied'
    end

    context 'requested by artists user' do
      let(:resource) {
        product = create(:product)
        product.add_artist!(user.artist)
        product.reload
      }
      # it_should_behave_like 'access granted'
      it { ability.should be_able_to :read, resource }
      it { ability.should be_able_to :stock, resource }
    end
  end

  context 'for Shipment' do
    context 'requested by another artists user' do
      let(:resource) { Spree::Shipment.new({stock_location: create(:stock_location, artist: create(:artist))}, without_protection: true) }
      it_should_behave_like 'access denied'
      it_should_behave_like 'no index allowed'
      it_should_behave_like 'admin denied'
      it { ability.should_not be_able_to :ready, resource }
      it { ability.should_not be_able_to :ship, resource }
    end

    context 'requested by artists user' do
      context 'when order is complete' do
        let(:resource) {
          order = create(:completed_order_for_drop_ship_with_totals)
          order.stock_locations.first.update_attribute :artist, user.artist
          Spree::Shipment.new({order: order, stock_location: order.stock_locations.first }, without_protection: true)
        }
        it_should_behave_like 'access granted'
        it_should_behave_like 'index allowed'
        it_should_behave_like 'admin granted'
        it { ability.should be_able_to :ready, resource }
        it { ability.should be_able_to :ship, resource }
      end

      context 'when order is incomplete' do
        let(:resource) { Spree::Shipment.new({stock_location: create(:stock_location, artist: user.artist)}, without_protection: true) }
        it_should_behave_like 'access denied'
        it { ability.should_not be_able_to :ready, resource }
        it { ability.should_not be_able_to :ship, resource }
      end
    end
  end

  context 'for StockItem' do
    let(:resource) { Spree::StockItem }

    it_should_behave_like 'index allowed'
    it_should_behave_like 'admin granted'

    context 'requested by another artists user' do
      let(:resource) {
        artist = create(:artist)
        variant = create(:product).master
        variant.product.add_artist! artist
        artist.stock_locations.first.stock_items.first
      }
      it_should_behave_like 'access denied'
    end

    context 'requested by artists user' do
      let(:resource) {
        variant = create(:product).master
        variant.product.add_artist! user.artist
        user.artist.stock_locations.first.stock_items.first
      }
      it_should_behave_like 'access granted'
    end
  end

  context 'for StockLocation' do
    context 'requsted by another artists user' do
      let(:resource) {
        artist = create(:artist)
        variant = create(:product).master
        variant.product.add_artist! artist
        artist.stock_locations.first
      }
      it_should_behave_like 'create only'
    end

    context 'requested by artists user' do
      let(:resource) {
        variant = create(:product).master
        variant.product.add_artist! user.artist
        user.artist.stock_locations.first
      }
      it_should_behave_like 'access granted'
      it_should_behave_like 'admin granted'
      it_should_behave_like 'index allowed'
    end
  end

  context 'for StockMovement' do
    let(:resource) { Spree::StockMovement }

    it_should_behave_like 'index allowed'
    it_should_behave_like 'admin granted'

    context 'requested by another artists user' do
      let(:resource) {
        artist = create(:artist)
        variant = create(:product).master
        variant.product.add_artist! artist
        Spree::StockMovement.new({ stock_item: artist.stock_locations.first.stock_items.first }, without_protection: true)
      }
      it_should_behave_like 'create only'
    end

    context 'requested by artists user' do
      let(:resource) {
        variant = create(:product).master
        variant.product.add_artist! user.artist
        Spree::StockMovement.new({ stock_item: user.artist.stock_locations.first.stock_items.first }, without_protection: true)
      }
      it_should_behave_like 'access granted'
    end
  end

  context 'for Artist' do
    context 'requested by any user' do
      let(:ability) { Spree::ArtistAbility.new(create(:user)) }
      let(:resource) { Spree::Artist }

      it_should_behave_like 'admin denied'
      it_should_behave_like 'access denied'
    end

    context 'requested by artists user' do
      let(:resource) { user.artist }
      it_should_behave_like 'admin granted'
      it_should_behave_like 'update only'
    end
  end

end