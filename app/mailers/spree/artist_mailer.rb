module Spree
  class ArtistMailer < Spree::BaseMailer

    default from: Spree::Store.current.mail_from_address

    def welcome(artist_id)
      @artist = Artist.find artist_id
      mail to: @artist.email, subject: Spree.t('artist_mailer.welcome.subject')
    end

  end
end