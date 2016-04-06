require 'spec_helper'

feature 'Admin - Product Stock Management', js: true do

  before do
    @user = create(:artist_user)
    @artist1 = @user.artist
    @artist2 = create(:artist)
    @product = create :product
    @product.add_artist! @artist1
  end

  context 'as Admin' do

    scenario 'should display all existing stock item locations' do
      login_user create(:admin_user)
      visit spree.stock_admin_product_path(@product)

      within '.stock_location_info' do
        page.should have_content(@artist1.name)
        # Stock item doesn't exist
        page.should_not have_content(@artist2.name)
      end
    end

  end

  context 'as Artist' do

    before(:each) do
      login_user @user
      visit '/admin/products'
      click_link "Stock Locations"
    end

    scenario 'should only display artists stock locations' do
      visit spree.stock_admin_product_path(@product)

      within '.stock_location_info' do
        page.should have_content(@artist1.name)
        page.should_not have_content(@artist2.name)
      end
    end

    scenario "can create a new stock location" do
      visit spree.new_admin_stock_location_path
      fill_in "Name", with: "London"
      check "Active"
      click_button "Create"

      page.should have_content("successfully created")
      page.should have_content("London")
    end

    scenario "can delete an existing stock location", js: true do
      create(:stock_location, artist: @user.artist)
      visit current_path

      find('#listing_stock_locations').should have_content("NY Warehouse")
      within_row(2) { click_icon :delete }
      page.driver.browser.switch_to.alert.accept
      # Wait for API request to complete.
      sleep(1)
      visit current_path

      find('#listing_stock_locations').should_not have_content("NY Warehouse")
    end

    scenario "can update an existing stock location" do
      create(:stock_location, artist: @user.artist)
      visit current_path

      page.should have_content("Big Store")

      within_row(1) { click_icon :edit }
      fill_in "Name", with: "London"
      click_button "Update"

      page.should have_content("successfully updated")
      page.should have_content("London")
    end

    scenario "can deactivate an existing stock location" do
      create(:stock_location, artist: @user.artist)
      visit current_path

      page.should have_content("Big Store")

      within_row(1) { click_icon :edit }
      uncheck "Active"
      click_button "Update"

      find('#listing_stock_locations').should have_content("Inactive")
    end

  end

end