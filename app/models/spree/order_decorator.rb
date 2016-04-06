Spree::Order.class_eval do

  has_many :stock_locations, through: :shipments
  has_many :artists, through: :stock_locations

  # Once order is finalized we want to notify the artists of their drop ship orders.
  # Here we are handling notification by emailing the artists.
  # If you want to customize this you could override it as a hook for notifying a artist with a API request instead.
  def finalize_with_artist_drop_ship!
    finalize_without_artist_drop_ship!
    shipments.each do |shipment|
      if SpreeArtistDropShip::Config[:send_artist_email] && shipment.artist.present?
        begin
          Spree::ArtistDropShipOrderMailer.artist_order(shipment.id).deliver!
        rescue => ex #Errno::ECONNREFUSED => ex
          puts ex.message
          puts ex.backtrace.join("\n")
          Rails.logger.error ex.message
          Rails.logger.error ex.backtrace.join("\n")
          return true # always return true so that failed email doesn't crash app.
        end
      end
    end
  end
  alias_method_chain :finalize!, :artist_drop_ship

end