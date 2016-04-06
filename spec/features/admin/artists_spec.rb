require 'spec_helper'

feature 'Admin - Artists', js: true do

  before do
    country = create(:country, name: "United States")
    create(:state, name: "Vermont", country: country)
    @artist = create :artist
  end

  context 'as an Admin' do

    before do
      login_user create(:admin_user)
      visit spree.admin_path
      within '[data-hook=admin_tabs]' do
        click_link 'Artists'
      end
      page.should have_content('Listing Artists')
    end

    scenario 'should be able to create new artist' do
      click_link 'New Artist'
      check 'artist_active'
      fill_in 'artist[name]', with: 'Test Artist'
      fill_in 'artist[email]', with: 'spree@example.com'
      fill_in 'artist[url]', with: 'http://www.test.com'
      fill_in 'artist[commission_flat_rate]', with: '0'
      fill_in 'artist[commission_percentage]', with: '0'
      fill_in 'artist[address_attributes][firstname]', with: 'First'
      fill_in 'artist[address_attributes][lastname]', with: 'Last'
      fill_in 'artist[address_attributes][address1]', with: '1 Test Drive'
      fill_in 'artist[address_attributes][city]', with: 'Test City'
      fill_in 'artist[address_attributes][zipcode]', with: '55555'
      select2 'United States', from: 'Country'
      select2 'Vermont', from: 'State'
      fill_in 'artist[address_attributes][phone]', with: '555-555-5555'
      click_button 'Create'
      page.should have_content('Artist "Test Artist" has been successfully created!')
    end

    scenario 'should be able to delete artist' do
      click_icon 'delete'
      page.driver.browser.switch_to.alert.accept
      within 'table' do
        page.should_not have_content(@artist.name)
      end
    end

    scenario 'should be able to edit artist' do
      click_icon 'edit'
      check 'artist_active'
      fill_in 'artist[name]', with: 'Test Artist'
      fill_in 'artist[email]', with: 'spree@example.com'
      fill_in 'artist[url]', with: 'http://www.test.com'
      fill_in 'artist[commission_flat_rate]', with: '0'
      fill_in 'artist[commission_percentage]', with: '0'
      fill_in 'artist[address_attributes][firstname]', with: 'First'
      fill_in 'artist[address_attributes][lastname]', with: 'Last'
      fill_in 'artist[address_attributes][address1]', with: '1 Test Drive'
      fill_in 'artist[address_attributes][city]', with: 'Test City'
      fill_in 'artist[address_attributes][zipcode]', with: '55555'
      select2 'United States', from: 'Country'
      select2 'Vermont', from: 'State'
      fill_in 'artist[address_attributes][phone]', with: '555-555-5555'
      click_button 'Update'
      page.should have_content('Artist "Test Artist" has been successfully updated!')
    end

  end

  context 'as a Artist' do
    before do
      @user = create(:artist_user)
      login_user @user
      visit spree.edit_admin_artist_path(@user.artist)
    end

    scenario 'should only see tabs they have access to' do
      within '[data-hook=admin_tabs]' do
        page.should_not have_link('Overview')
        page.should have_link('Products')
        page.should_not have_link('Reports')
        page.should_not have_link('Configuration')
        page.should_not have_link('Promotions')
        page.should_not have_link('Artist')
        page.should have_link('Shipments')
      end
    end

    scenario 'should be able to update artist' do
      fill_in 'artist[name]', with: 'Test Artist'
      fill_in 'artist[email]', with: @user.email
      fill_in 'artist[url]', with: 'http://www.test.com'
      fill_in 'artist[address_attributes][firstname]', with: 'First'
      fill_in 'artist[address_attributes][lastname]', with: 'Last'
      fill_in 'artist[address_attributes][address1]', with: '1 Test Drive'
      fill_in 'artist[address_attributes][city]', with: 'Test City'
      fill_in 'artist[address_attributes][zipcode]', with: '55555'
      select2 'United States', from: 'Country'
      select2 'Vermont', from: 'State'
      fill_in 'artist[address_attributes][phone]', with: '555-555-5555'
      page.should_not have_css('#artist_active') # cannot edit active
      page.should_not have_css('#artist_featured') # cannot edit featured
      page.should_not have_css('#s2id_artist_user_ids') # cannot edit assigned users
      page.should_not have_css('#artist_commission_flat_rate') # cannot edit flat rate commission
      page.should_not have_css('#artist_commission_percentage') # cannot edit comission percentage
      click_button 'Update'
      page.should have_content('Artist "Test Artist" has been successfully updated!')
      page.current_path.should eql(spree.edit_admin_artist_path(@user.reload.artist))
    end

  end

  context 'as a User other than the artists' do

    scenario 'should be unauthorized' do
      artist = create(:artist)
      login_user create(:user)
      visit spree.edit_admin_artist_path(artist)
      page.should have_content('Authorization Failure')
    end

  end

end