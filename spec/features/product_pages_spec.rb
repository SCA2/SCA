require 'rails_helper'

feature "Products" do
  
  context "as a guest" do

    before(:all) do
      3.times do
        product = create(:product)
        create(:feature, product: product)
        create(:option, product: product)
      end
    end
    after(:all) { DatabaseCleaner.clean_with(:truncation) }

    scenario 'get products index' do
      visit home_path
      expect(page).to have_link 'Products'
      find(:link_or_button, 'Products').click
      expect(current_path).to eq products_path
      expect(page).to have_title('Products')
    end

    scenario 'add product to cart' do
      visit products_path
      expect(page).to have_content('0 Items')
      # save_and_open_page; 
      first(:button, 'Add to Cart').click
      expect(page).to have_content('1 Items')
    end

    scenario 'view large product page' do
      @first = Product.first
      visit product_path(@first)
      expect(page).to have_title(@first.model)
      expect(page).to have_content(@first.model)
      expect(page).to have_content(@first.features.first.caption)
      expect(page).to have_content(@first.features.first.description)
      expect(page).to have_content(@first.options.first.model)
      expect(page).to have_content(@first.options.first.description)
    end

    scenario 'checkout - normal'
    scenario 'checkout - PayPal Express'

  end

  context "as an admin" do

    let(:admin)   { create(:admin) }
    let(:product) { build(:product) }
    let(:option)  { build(:option) }
    
    before { test_sign_in admin }

    context "with no products" do
    
      scenario 'add a product' do
        visit products_path
        expect(page).to have_selector(:link_or_button, 'New Product')
        first(:link_or_button, 'New Product').click
        expect(page).to have_content('New Product')
        fill_in_product(product)
        find(:link_or_button, 'Create').click
        expect(page).to have_content('Product must have at least one option!')
        fill_in_option(option)
        find(:link_or_button, 'Create').click
        expect(page).to have_title(product.model)
        expect(page).to have_content('Success!')
      end

    end

    context "with products" do

      before(:all) do
        3.times do
          product = create(:product)
          create(:feature, product: product)
          create(:option, product: product)
        end
      end
      
      after(:all) { DatabaseCleaner.clean_with(:truncation) }

      let(:feature) { build(:feature) }
      let(:option) { build(:option) }

      before(:each) do
        @first = Product.first
        visit product_path(@first)
      end

      scenario 'get products index' do
        visit home_path
        expect(page).to have_link 'Products'
        find(:link_or_button, 'Products').click
        expect(current_path).to eq products_path
        expect(page).to have_title('Products')
        expect(page).to have_link('New Product')
      end

      scenario 'view large product page' do
        expect(page).to have_title(@first.model)
        expect(page).to have_content(@first.model)
        expect(page).to have_content(@first.features.first.caption)
        expect(page).to have_content(@first.features.first.description)
        expect(page).to have_content(@first.options.first.model)
        expect(page).to have_content(@first.options.first.description)
      end
    
      scenario 'add a product feature' do
        click_link 'New Feature'
        fill_in_feature(feature)
        expect { click_button 'Create' }.to change(Feature, :count).by(1)
      end

      scenario 'add a product option' do
        click_link 'New Option'
        fill_in_option(option)
        expect { click_button 'Create' }.to change(Option, :count).by(1)
      end

      scenario 'delete a product' do
        expect { click_link 'Delete Product' }.to change(Product, :count).by(-1)
      end
      
    end
  end
end
