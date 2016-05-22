require 'rails_helper'

feature "Shopping Cart" do
  context "as a guest" do

    before(:all) do
      product = create(:product)
      create(:feature, product: product)
      create(:option, product: product)
    end

    after(:all) { DatabaseCleaner.clean_with(:truncation) }

    scenario 'page contains cart links' do
      visit products_path
      expect(page).to have_content '0 Items'
    end

    scenario 'add product to cart' do
      visit products_path
      first(:button, 'Add to Cart').click
      expect(page).to have_content('1 Items')
    end

    scenario 'change quantity and update' do
      visit products_path
      first(:button, 'Add to Cart').click
      visit cart_path(Cart.last)
      fill_in('cart_line_items_attributes_0_quantity', with: '2')
      click_on('Update cart')
      expect(page).to have_content('2 Items')
    end

    scenario 'remove item' do
      visit products_path
      first(:button, 'Add to Cart').click
      visit cart_path(Cart.last)
      check('cart_line_items_attributes_0__destroy')
      click_on('Update cart')
      expect(page).to have_content('Your cart is empty!')
    end

    scenario 'clear cart' do
      visit products_path
      first(:button, 'Add to Cart').click
      visit cart_path(Cart.last)
      click_on('Empty cart')
      expect(page).to have_content('Your cart is empty!')
    end
  end
end
