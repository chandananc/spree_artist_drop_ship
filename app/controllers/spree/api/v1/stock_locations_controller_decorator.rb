Spree::Api::V1::StockLocationsController.class_eval do

  before_filter :artist_locations, only: [:index]
  before_filter :artist_transfers, only: [:index]

  private

  def artist_locations
    params[:q] ||= {}
    params[:q][:artist_id_eq] = spree_current_user.artist_id
  end

  def artist_transfers
    params[:q] ||= {}
    params[:q][:artist_id_eq] = spree_current_user.artist_id
  end

end