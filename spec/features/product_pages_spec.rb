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

    let(:admin) { create(:admin) }
    let(:product) { build(:product) }
    let(:option) { build(:option) }
    before { test_sign_in admin }

    context "with no products" do
      scenario 'add a product' do
        visit products_path
        expect(page).to have_selector(:link_or_button, 'New Product')
        first(:link_or_button, 'New Product').click
        expect(page).to have_content('Create Product')
        fill_in_product(product)
        find(:link_or_button, 'Save').click
        expect(page).to have_selector('div.alert-box')
        expect(page).to have_content('Product was successfully created.')
        fill_in_option(option)
        find(:link_or_button, 'Save').click
        # save_and_open_page
        expect(page).to have_title(product.model)
        expect(page).to have_selector('div.alert-box')
        expect(page).to have_content('Option was successfully created.')
      end

      scenario 'add a product feature'
      scenario 'add a product option'
      scenario 'view large product page'
      scenario 'delete a product'
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

      scenario 'get products index' do
        visit home_path
        expect(page).to have_link 'Products'
        find(:link_or_button, 'Products').click
        expect(current_path).to eq products_path
        expect(page).to have_title('Products')
        expect(page).to have_link('New Product')
      end

      scenario 'large product page' do
        @first = Product.first
        visit product_path(@first)
        expect(page).to have_title(@first.model)
        expect(page).to have_content(@first.model)
        expect(page).to have_content(@first.features.first.caption)
        expect(page).to have_content(@first.features.first.description)
        expect(page).to have_content(@first.options.first.model)
        expect(page).to have_content(@first.options.first.description)
      end
    end
    
    # describe 'add new feature to product' do
    #   let(:product) { FactoryGirl.create(:product) }
    #   before { visit product_path(product) }
    #   subject { page }
      
    #   context 'with invalid information' do
    #     before { click_link 'New Feature' }
        
    #     it 'should not create a feature' do
    #       expect { click_button 'Save' }.not_to change(Feature, :count)
    #     end
        
    #     describe 'error messages' do
    #       before { click_button 'Save' }
    #       it { should have_content('error') }
    #     end
    #   end
      
    #   context 'with valid information' do
    #     before { click_link 'New Feature' }
    #     it 'should create a feature' do
    #       fill_in 'Sort Order', with: 20
    #       fill_in 'Caption', with: 'Caption text'
    #       fill_in 'Description', with: 'Description text'
    #       expect { click_button 'Save' }.to change(Feature, :count).by(1)
    #     end
    #   end
    # end
  end
end
