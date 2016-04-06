module Spree
  class ArtistDropShipConfiguration < Preferences::Configuration

    # Automatically deliver drop ship orders by default.
    preference :automatically_deliver_orders_to_artist, :boolean, default: true

    # Default flat rate to charge artists per order for commission.
    preference :default_commission_flat_rate, :float, default: 0.0

    # Default percentage to charge artists per order for commission.
    preference :default_commission_percentage, :float, default: 0.0

    # Determines whether or not to email a new artist their welcome email.
    preference :send_artist_email, :boolean, default: true

  end
end