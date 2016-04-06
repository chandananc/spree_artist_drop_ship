require 'spec_helper'

describe Spree::Order do

  context '#finalize_with_drop_ship!' do

    after do
      SpreeDropShip::Config[:send_artist_email] = true
    end

    it 'should deliver drop ship orders when Spree::DropShipConfig[:send_artist_email] == true' do
      order = create(:order_with_totals, ship_address: create(:address))
      order.line_items = [create(:line_item, variant: create(:variant_with_artist)), create(:line_item, variant: create(:variant_with_artist))]
      order.create_proposed_shipments

      order.shipments.each do |shipment|
        Spree::DropShipOrderMailer.should_receive(:artist_order).with(shipment.id).and_return(double(Mail, :deliver! => true))
      end

      order.finalize!
      order.reload

      # Check orders are properly split.
      order.shipments.size.should eql(2)
      order.shipments.each do |shipment|
        shipment.line_items.size.should eql(1)
        shipment.line_items.first.variant.artists.first.should eql(shipment.artist)
      end
    end

    it 'should NOT deliver drop ship orders when Spree::DropShipConfig[:send_artist_email] == false' do
      SpreeDropShip::Config[:send_artist_email] = false
      order = create(:order_with_totals, ship_address: create(:address))
      order.line_items = [create(:line_item, variant: create(:variant_with_artist)), create(:line_item, variant: create(:variant_with_artist))]
      order.create_proposed_shipments

      order.shipments.each do |shipment|
        Spree::DropShipOrderMailer.should_not_receive(:artist_order).with(shipment.id)
      end

      order.finalize!
      order.reload

      # Check orders are properly split.
      order.shipments.size.should eql(2)
      order.shipments.each do |shipment|
        shipment.line_items.size.should eql(1)
        shipment.line_items.first.variant.artists.first.should eql(shipment.artist)
      end
    end

  end

end