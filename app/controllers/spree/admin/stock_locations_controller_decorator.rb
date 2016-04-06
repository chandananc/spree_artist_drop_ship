Spree::Admin::StockLocationsController.class_eval do

  create.after :set_artist

  private

  def set_artist
    if try_spree_current_user.artist?
      @object.artist = try_spree_current_user.artist
      @object.save
    end
  end

end