require 'rails_helper'

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
#      find(:link_or_button, 'Add to cart').click
#      expect(:items_in_cart).to change_by(1)
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
      expect(page).to have_link('New Product')
    end

    describe 'large product page' do
      let(:product) { FactoryGirl.create(:product, model: 'A12') }
      let!(:f1) { FactoryGirl.create(:feature, product: product, caption: 'Foo') }
      let!(:f2) { FactoryGirl.create(:feature, product: product, caption: 'Bar') }
      
      before { visit product_path(product) }
      subject { page }
      
      it { should have_title(product.model) }
      it { should have_content(product.model) }
      
      describe 'features' do
        it { should have_content('Foo') }
        it { should have_content(f1.caption) }
        it { should have_content(f1.description) }
        it { should have_content(f2.caption) }
        it { should have_content(f2.description) }
      end
    end
    
    describe 'add new feature to product' do
      let(:product) { FactoryGirl.create(:product) }
      before { visit product_path(product) }
      subject { page }
      
      context 'with invalid information' do
        before { click_link 'New Feature' }
        
        it 'should not create a feature' do
          expect { click_button 'Save' }.not_to change(Feature, :count)
        end
        
        describe 'error messages' do
          before { click_button 'Save' }
          it { should have_content('error') }
        end
      end
      
      context 'with valid information' do
        before { click_link 'New Feature' }
        it 'should create a feature' do
          fill_in 'Sort Order', with: 20
          fill_in 'Caption', with: 'Caption text'
          fill_in 'Description', with: 'Description text'
          expect { click_button 'Save' }.to change(Feature, :count).by(1)
        end
      end
    end
    
  end
end
