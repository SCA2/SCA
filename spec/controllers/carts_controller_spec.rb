require 'rails_helper'

describe CartsController do
  context 'all access' do
    describe "GET #show" do
      context "with no cart in the session" do
        it "creates a new cart assigned to @cart" do
          get :show, { id: 0 }
          expect(assigns(:cart)).to eq(Cart.last)
        end
      end

      context "with a cart in the session" do
        it "assigns the requested cart as @cart" do
            cart = create(:cart)
            session[:cart_id] = cart.id
            get :show, { id: cart }
            expect(assigns(:cart)).to eq(cart)
          end
      end
    end

    describe "PATCH #update" do
      context "with no cart in the session" do
        it "creates a new cart assigned to @cart" do
          post :update, id: 0, cart: attributes_for(:cart)
          expect(assigns(:cart)).to eq(Cart.last)
        end
      end

      context "with a cart in the session" do
        
        let(:cart) { create(:cart) }

        it "updates the requested cart" do
          session[:cart_id] = cart.id
          post :update, id: cart.id, cart: attributes_for(:cart)
          expect(assigns(:cart)).to eq(cart)
        end

        it "redirects to the products list" do
          session[:cart_id] = cart.id
          post :update, id: cart.id, cart: attributes_for(:cart)
          expect(response).to redirect_to(cart)
        end
      end
    end

    describe "DELETE #destroy", :vcr do

      let!(:cart) { create(:cart) }
      let!(:order) { create(:stripe_order, cart: cart) }

      it "destroys the requested cart" do
        session[:cart_id] = cart.id
        expect { delete :destroy, {id: cart} }.to change { Cart.count }.by(-1)
      end

      it "destroys the associated order" do
        session[:cart_id] = cart.id
        expect { delete :destroy, {id: cart} }.to change{ Order.count }.by(-1)
      end

      it "destroys the associated line_item" do
        session[:cart_id] = cart.id
        product = create(:product)
        option = create(:option, product: product)
        create(:line_item, cart: cart, product: product, option: option)
        expect { delete :destroy, {id: cart} }.to change{ LineItem.count }.by(-1)
      end

      it "redirects to the products list" do
        session[:cart_id] = cart.id
        delete :destroy, {id: cart}
        expect(response).to redirect_to(products_path)
      end
    end
  end
end
