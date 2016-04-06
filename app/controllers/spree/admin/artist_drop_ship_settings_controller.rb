class Spree::Admin::ArtistDropShipSettingsController < Spree::Admin::BaseController

  def edit
    @config = Spree::ArtistDropShipConfiguration.new
  end

  def update
    config = Spree::ArtistDropShipConfiguration.new

    params.each do |name, value|
      next unless config.has_preference? name
      config[name] = value
    end

    flash[:success] = Spree.t('admin.artist_drop_ship_settings.update.success')
    redirect_to spree.edit_admin_artist_drop_ship_settings_path
  end

end