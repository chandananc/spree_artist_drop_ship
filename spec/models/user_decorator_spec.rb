require 'spec_helper'

describe Spree.user_class do

  it { should belong_to(:artist) }

  it { should have_many(:variants).through(:artist) }

  let(:user) { build :user }

  it '#artist?' do
    user.artist?.should be false
    user.artist = build :artist
    user.artist?.should be true
  end

end