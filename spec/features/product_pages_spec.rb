require 'spec_helper'

feature "Products" do
  context "as a guest" do
    scenario 'get products index' do
      visit home_path
      expect(page).to have_link 'Products'
      find(:link_or_button, 'Products').click
      expect(current_path).to eq products_path
      expect(page).to have_title('Products')
    end
    scenario 'add product to cart' do
      visit products_path
      expect(current_path).to eq products_path
      find(:link_or_button, 'Add to cart').click
      expect(:items_in_cart).to change_by(1)
    end
  end
  context "as an admin" do
    let(:admin) { FactoryGirl.create(:admin) }

    before { sign_in admin }

    scenario 'get products index' do
      visit home_path
      expect(page).to have_link 'Products'
      find(:link_or_button, 'Products').click
      expect(current_path).to eq products_path
      expect(page).to have_title('Products')
      expect(page).to have_link('Add Product')
    end
    scenario 'add product to database'
  end
end
