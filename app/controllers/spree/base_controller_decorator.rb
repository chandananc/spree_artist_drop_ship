Spree::BaseController.class_eval do

  prepend_before_filter :redirect_artist

  private

  def redirect_artist
    if ['/admin', '/admin/authorization_failure'].include?(request.path) && try_spree_current_user.try(:artist)
      redirect_to '/admin/shipments' and return false
    end
  end

end