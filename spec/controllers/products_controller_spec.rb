require 'rails_helper'

describe ProductsController do
  
  let(:product) { create(:product) }
  let(:option) { create(:option, product: product) }
  let(:valid_attributes) { build(:product).attributes }
  
  shared_examples('guest access to products') do
    describe "GET index" do
      it "assigns all products as @products" do
        product = Product.create! valid_attributes
        get :index, {}
        expect(assigns(:products)).to eq([product])
      end
    end
  
    describe "GET show" do
      it "assigns the requested product as @product" do
        get :show, id: product.to_param
        expect(assigns(:product)).to eq(product)
      end

      it "finds hard-coded products" do
        product = create(:product, model: 'A12')
        create(:option, product: product)
        get :show, id: 'a12'
        expect(assigns(:product)).to eq(product)
      end

      it "finds longest product name first in id string" do
        product = create(:product, model: 'CH02-SP')
        create(:option, product: product)
        get :show, id: 'asdf/1234/n72a12bch02-sp'
        expect(assigns(:product)).to eq(product)
      end

      it "redirects to products path with bogus id" do
        product = create(:product, model: 'A12B')
        create(:option, product: product)
        get :show, id: 'bogus'
        expect(response).to redirect_to(products_path)
      end
    end
  end  

  shared_examples('admin access to products') do  
    describe "GET new" do
      it "assigns a new product as @product" do
        get :new, {}
        expect(assigns(:product)).to be_a_new(Product)
      end
    end
  
    describe "GET edit" do
      it "assigns the requested product as @product" do
        get :edit, id: product
        expect(assigns(:product)).to eq(product)
      end
    end
  
    describe "POST create" do
      describe "with valid params" do
        it "creates a new Product" do
          expect {
            post :create, product: valid_attributes
          }.to change(Product, :count).by(1)
        end
  
        it "assigns a newly created product as @product" do
          post :create, product: valid_attributes
          expect(assigns(:product)).to be_a(Product)
          expect(assigns(:product)).to be_persisted
        end
  
        it "redirects to the created product" do
          post :create, product: valid_attributes
          expect(response).to redirect_to(Product.last)
        end
      end
  
      describe "with invalid params" do
        it "assigns a newly created but unsaved product as @product" do
          allow(product).to receive(:save).and_return(false)
          post :create, product: { model_weight: 0 }
          expect(assigns(:product)).to be_a_new(Product)
        end
  
        it "re-renders the 'new' template" do
          allow(product).to receive(:save).and_return(false)
          post :create, product: { model_weight: 0 }
          expect(response).to render_template("new")
        end
      end
    end
  
    describe "PATCH #update" do
      
      before { product.options << option }
      
      describe "with valid params" do
        it "updates the requested product" do
          expect_any_instance_of(Product).to receive(:update).with( { model: 'A12KF'} )
          patch :update, id: product, product: { model: 'A12KF' }
        end
  
        it "assigns the requested product as @product" do
          patch :update, id: product, product: valid_attributes
          expect(assigns(:product)).to eq(product)
        end
  
        it "redirects to the product" do
          patch :update, id: product,
            product: attributes_for(:product, model: product.model)
          expect(response).to redirect_to(product)
        end

        it "redirects to the product index with bogus id" do
          patch :update, id: 'bogus',
            product: attributes_for(:product, model: product.model)
          expect(response).to redirect_to(products_path)
        end
      end
  
      describe "with invalid params" do
        it "assigns the product as @product" do
          allow(product).to receive(:save).and_return(false)
          patch :update, id: product, product: { model: nil }
          expect(assigns(:product)).to eq(product)
        end
  
        it "re-renders the 'edit' template" do
          allow(product).to receive(:save).and_return(false)
          patch :update, id: product.to_param, product: { model: nil }
          expect(response).to render_template("edit")
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
          delete :destroy, id: product
        }.to change(Product, :count).by(-1)
      end
  
      it "redirects to the products list" do
        delete :destroy, id: product
        expect(response).to redirect_to(products_path)
      end

      it "alerts if product is referenced by a cart" do
        cart = create(:cart)
        create(:line_item, cart: cart, product: product, option: option)
        delete :destroy, id: product
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'admin access to products' do
    let(:admin) { create(:admin) }
    before { test_sign_in(admin, false) }
    it_behaves_like 'admin access to products'
    it_behaves_like 'guest access to products'
  end

end
