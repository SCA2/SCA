require 'rails_helper'

feature "product category" do
  
  context "as a guest" do
    let(:product_category) { build_stubbed(:product_category) }
    scenario 'view index' do
      visit product_categories_path
      expect(page).to have_content("admins only")
    end
    scenario 'edit product category' do
      visit edit_product_category_path(product_category)
      expect(page).to have_content("admins only")
    end
    scenario 'delete product category' do
      visit product_categories_path
      expect(page).to have_content("admins only")
    end
  end

  context "as an admin" do

    let(:admin) { create(:admin) }
    before      { test_sign_in admin }
    after(:all) { DatabaseCleaner.clean_with(:truncation) }

    scenario 'view product categories index' do
      product_category = create(:product_category)
      visit '/admin'
      click_link 'View Product Categories'
      expect(page).to have_content(product_category.name)
      expect(page).to have_content(product_category.sort_order)
    end

    scenario 'add a new product category' do
      product_category = build_stubbed(:product_category)
      visit product_categories_path
      expect(page).to have_selector(:link_or_button, 'New Product Category')
      first(:link_or_button, 'New Product Category').click
      expect(page).to have_content('New Product Category')
      fill_in_product_category(product_category)
      find(:link_or_button, 'Create').click
      expect(page).to have_content("Product Category #{product_category.name} created")
    end

    scenario 'view product_category edit page' do
      product_category = create(:product_category)
      visit edit_product_category_path(product_category)
      expect(page).to have_field("Category Name:", with: product_category.name)
      expect(page).to have_field("Sort Order:", with: product_category.sort_order)
    end

    scenario 'update an existing product category' do
      product_category = create(:product_category)
      visit product_categories_path
      expect(page).to have_content("#{product_category.name}")
      find(:link_or_button, 'edit').click
      fill_in_product_category(product_category)
      find(:link_or_button, 'Update').click
      expect(page).to have_content("Product Category #{product_category.name} updated")
    end

    scenario 'delete a product category' do
      product_category = create(:product_category)
      bom_id = product_category.id
      visit product_categories_path
      expect { click_link 'delete' }.to change(ProductCategory, :count).by(-1)
    end
  end
end
