require 'spec_helper'

describe 'Admin - Products', js: true do

  context 'as Admin' do

    xit 'should be able to change artist' do
      s1 = create(:artist)
      s2 = create(:artist)
      product = create :product
      product.add_artist! s1

      login_user create(:admin_user)
      visit spree.admin_product_path(product)

      select2 s2.name, from: 'Artist'
      click_button 'Update'

      expect(page).to have_content("Product \"#{product.name}\" has been successfully updated!")
      expect(product.reload.artists.first.id).to eql(s2.id)
    end

  end

end