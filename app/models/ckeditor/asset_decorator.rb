if defined?(Ckeditor)
  Ckeditor::Asset.class_eval do
    belongs_to :artist, class_name: 'Spree::Artist'
  end
end