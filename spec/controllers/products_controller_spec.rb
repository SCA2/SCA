require 'rails_helper'

describe ProductsController do
  
  let(:product) { create(:product) }
  let!(:option) { create(:option, product: product) }
  let(:valid_attributes) { build(:product).attributes }
  
  shared_examples('guest access to products') do
    describe "GET index" do
      it "is successful" do
        get :index
        expect(response).to be_successful
      end
    end
  
    describe "GET show" do
      it "is successful" do
        get :show, params: { id: product.to_param }
        expect(response).to be_successful
      end

      it "finds hard-coded products" do
        product = create(:product, model: 'A12')
        create(:option, product: product)
        get :show, params: { id: 'a12' }
        expect(response).to be_successful
      end

      it "finds product by alphabetical order in id string" do
        product = create(:product, model: 'A12B')
        create(:option, product: product)
        get :show, params: { id: 'asdf/1234/n72a12bch02-sp' }
        expect(response).to be_successful
      end

      it "redirects to products path with bogus id" do
        product = create(:product, model: 'A12B')
        create(:option, product: product)
        get :show, params: { id: 'bogus' }
        expect(response).to redirect_to(products_path)
      end
    end

    describe "GET update_option" do
      it "assigns new option to @option" do
        get :update_option, params: { product: {options: option}, id: product, format: :js }, xhr: true
        expect(response).to be_successful
      end
    end
  end  

  shared_examples('admin access to products') do  
    describe "GET new" do
      it "assigns a new product as @product" do
        get :new
        expect(response).to be_successful
      end
    end
  
    describe "GET edit" do
      it "assigns the requested product as @product" do
        get :edit, params: { id: product }
        expect(response).to be_successful
      end
    end
  
    describe "POST create" do
      describe "with valid params" do
        it "creates a new Product" do
          expect {
            post :create, params: { product: valid_attributes }
          }.to change(Product, :count).by(1)
        end
  
        it "redirects to the created product" do
          post :create, params: { product: valid_attributes }
          expect(response).to redirect_to(Product.last)
        end
      end
  
      describe "with invalid params" do
        it "assigns a newly created but unsaved product as @product" do
          allow(product).to receive(:save).and_return(false)
          post :create, params: { product: { model_weight: 0 } }
          expect(response).to be_successful
        end
  
        it "re-renders the 'new' template" do
          allow(product).to receive(:save).and_return(false)
          post :create, params: { product: { model_weight: 0 } }
          expect(response).to be_successful
        end
      end
    end
  
    describe "PATCH #update" do
      
      before { product.options << option }
      
      describe "with valid params" do
        it "updates the requested product" do
          product.update(model: 'FOO')
          patch :update, params: { id: product, product: { model: 'bar' }}
          product.reload
          expect(product.model).to eq('bar')
        end
  
        it "redirects to the product" do
          patch :update, params: { id: product,
            product: attributes_for(:product, model: product.model)}
          expect(response).to redirect_to(product)
        end

        it "redirects to the product index with bogus id" do
          patch :update, params: { id: 'bogus',
            product: attributes_for(:product, model: product.model)}
          expect(response).to redirect_to(products_path)
        end
      end
  
      describe "with invalid params" do
        it "assigns the product as @product" do
          allow(product).to receive(:save).and_return(false)
          patch :update, params: { id: product, product: { model: nil }}
          expect(response).to be_successful
        end
  
        it "re-renders the 'edit' template" do
          allow(product).to receive(:save).and_return(false)
          patch :update, params: { id: product.to_param, product: { model: nil }}
          expect(response).to be_successful
        end
      end
    end
  
    describe "DELETE destroy" do
      
      before do
        product.options << option
        product.save!
      end
      
      it "destroys the requested product" do
        expect {
          delete :destroy, params: { id: product }
        }.to change(Product, :count).by(-1)
      end
  
      it "redirects to the products list" do
        delete :destroy, params: { id: product }
        expect(response).to redirect_to(products_path)
      end

      it "alerts if product is referenced by a cart" do
        cart = create(:cart)
        create(:line_item, cart: cart, option: option)
        delete :destroy, params: { id: product }
        expect(flash[:alert]).to include("Product #{product.model} is referenced by cart #{cart.id}")
      end
    end
  end

  describe 'admin access to products' do
    let(:admin) { create(:admin) }
    before { test_sign_in(admin, use_capybara: false) }
    it_behaves_like 'admin access to products'
    it_behaves_like 'guest access to products'
  end

end
