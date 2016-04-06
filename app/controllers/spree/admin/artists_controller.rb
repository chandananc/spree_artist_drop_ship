class Spree::Admin::ArtistsController < Spree::Admin::ResourceController

  def edit
    @object.address = Spree::Address.default unless @object.address.present?
    respond_with(@object) do |format|
      format.html { render :layout => !request.xhr? }
      format.js   { render :layout => false }
    end
  end

  def new
    @object = Spree::Artist.new(address_attributes: {country_id: Spree::Address.default.country_id})
  end

  private

    def collection
      params[:q] ||= {}
      params[:q][:meta_sort] ||= "name.asc"
      @search = Spree::Artist.search(params[:q])
      @collection = @search.result.page(params[:page]).per(Spree::Config[:orders_per_page])
    end

    def find_resource
      Spree::Artist.friendly.find(params[:id])
    end

    def location_after_save
      spree.edit_admin_artist_path(@object)
    end

end