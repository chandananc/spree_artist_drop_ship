module Spree
  module Stock
    module Splitter
      class ArtistDropShip < Spree::Stock::Splitter::Base

        def split(packages)
          split_packages = []
          packages.each do |package|
            # Package fulfilled items together.
            fulfilled = package.contents.select { |content| content.variant.artists.count == 0 }
            split_packages << build_package(fulfilled)
            # Determine which artist to package drop shipped items.
            artist_drop_ship = package.contents.select { |content| content.variant.artists.count > 0 }
            artist_drop_ship.each do |content|
              # Select the related variant
              variant = content.variant
              # Select artists ordering ascending according to cost.
              artists = variant.artist_variants.order("spree_artist_variants.cost ASC").map(&:artist)
              # Select first artist that has stock location with avialable stock item.
              available_artist = artists.detect do |artist| 
                artist.stock_locations_with_available_stock_items(variant).any?
              end
              # Select the first available stock location with in the available_artist stock locations.
              stock_location = available_artist.stock_locations_with_available_stock_items(variant).first
              # Add to any existing packages or create a new one.
              if existing_package = split_packages.detect { |p| p.stock_location == stock_location }
                existing_package.contents << content
              else
                split_packages << Spree::Stock::Package.new(stock_location, [content])
              end
            end
          end
          return_next split_packages
        end

      end
    end
  end
end