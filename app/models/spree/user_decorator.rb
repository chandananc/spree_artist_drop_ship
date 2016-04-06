Spree.user_class.class_eval do

  belongs_to :artist, class_name: 'Spree::Artist'

  has_many :variants, through: :artist

  def artist?
    artist.present?
  end

end