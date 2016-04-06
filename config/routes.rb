Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :admin do
    resource :artist_drop_ship_settings
    resources :shipments
    resources :artists
  end
end
