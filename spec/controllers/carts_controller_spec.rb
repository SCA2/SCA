require 'rails_helper'

describe CartsController do
  context 'all access' do
    describe "GET #show" do
      context "with no cart in the session" do
        it "creates a new cart" do
          expect{ get :show, params: { id: 0 } }.to change{ Cart.count }.by(1)
        end
      end

      context "with a cart in the session" do
        it "assigns the requested cart as @cart" do
            cart = create(:cart)
            session[:cart_id] = cart.id
            get :show, params: { id: cart }
            expect(Cart.last).to eq(cart)
          end
      end
    end

    describe "PATCH #update" do
      context "with no cart in the session" do
        it "creates a new cart" do
          expect{ post :update, params: { id: 0, cart: attributes_for(:cart) } }.to change{ Cart.count }.by(1)
        end
      end

      context "with a cart in the session" do
        
        let(:cart) { create(:cart) }

        it "updates the requested cart" do
          session[:cart_id] = cart.id
          post :update, params: { id: cart.id, cart: attributes_for(:cart) }
          expect(Cart.find(cart.id)).to eq(cart)
        end

        it "redirects to the products list" do
          session[:cart_id] = cart.id
          post :update, params: { id: cart.id, cart: attributes_for(:cart) }
          expect(response).to redirect_to(cart)
        end
      end
    end

    describe "DELETE #destroy", :vcr do

      let!(:cart) { create(:cart) }
      let!(:order) { create(:stripe_order, cart: cart) }

      it "destroys the requested cart" do
        session[:cart_id] = cart.id
        expect { delete :destroy, params: { id: cart } }.to change { Cart.count }.by(-1)
      end

      it "destroys the associated order" do
        session[:cart_id] = cart.id
        expect { delete :destroy, params: { id: cart } }.to change{ Order.count }.by(-1)
      end

      it "destroys the associated line_item" do
        session[:cart_id] = cart.id
        create(:line_item, cart: cart)
        expect { delete :destroy, params: { id: cart } }.to change{ LineItem.count }.by(-1)
      end

      it "redirects to the products list" do
        session[:cart_id] = cart.id
        delete :destroy, params: { id: cart }
        expect(response).to redirect_to(products_path)
      end
    end
  end
end
