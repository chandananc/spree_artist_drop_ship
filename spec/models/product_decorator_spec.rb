require 'spec_helper'

describe Spree::Product do

  let(:product) { create :product }

  it '#artist?' do
    product.artist?.should eq false
    product.add_artist! create(:artist)
    product.reload.artist?.should eq true
  end

end