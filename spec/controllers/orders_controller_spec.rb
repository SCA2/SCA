require 'rails_helper'

describe OrdersController do
  describe 'GET #index' do
    context 'with logged in admin' do
      let(:admin) { create(:admin) }
      before do
        test_sign_in(admin, false)
        get :index
      end
      it 'responds with status :ok' do
        expect(response).to have_http_status :ok
      end
      it 'responds with content type html' do
        expect(response.content_type).to eq('text/html')
      end
      it 'renders the application layout' do
        expect(response).to render_template(layout: 'layouts/application')
      end
      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
    end

    context 'as a guest' do
      before do
        get :index
      end
      it 'redirects to home page' do
        expect(response).to redirect_to home_path
      end
      it 'sets the flash' do
        expect(flash[:alert]).to eq 'Sorry, admins only'
      end
    end
  end

  describe "GET #show" do
    context 'with logged in admin and valid order' do
      let(:admin) { create(:admin) }
      before do
        test_sign_in(admin, false)
        cart = create(:cart)
        order = create(:order, cart: cart, express_token: nil)
        create(:address, address_type: 'billing', addressable: order)
        create(:address, address_type: 'shipping', addressable: order)
        session[:cart_id] = cart.id
        get :show, id: order
      end
      it 'responds with status :ok' do
        expect(response).to have_http_status :ok
      end
      it 'responds with content type html' do
        expect(response.content_type).to eq('text/html')
      end
      it 'renders the application layout' do
        expect(response).to render_template(layout: 'layouts/application')
      end
      it 'renders the show template' do
        expect(response).to render_template(:show)
      end
      it "renders a valid order" do
        expect(response).to render_template(:show)
      end
    end

    context 'with logged in admin and invalid order' do
      let(:admin) { create(:admin) }
      before do
        test_sign_in(admin, false)
        cart = create(:cart)
        order = create(:order, cart: cart, express_token: nil)
        create(:address, address_type: 'billing', addressable: order)
        session[:cart_id] = cart.id
        get :show, id: order
      end
      it "redirects with an invalid order" do
        expect(response).to redirect_to(orders_path)
      end
    end

    context 'as a guest' do
      before do
        cart = create(:cart)
        order = create(:order, cart: cart, express_token: nil)
        create(:address, address_type: 'billing', addressable: order)
        create(:address, address_type: 'shipping', addressable: order)
        session[:cart_id] = cart.id
        get :show, id: order
      end
      it 'redirects to home page' do
        expect(response).to redirect_to home_path
      end
      it 'sets the flash' do
        expect(flash[:alert]).to eq 'Sorry, admins only'
      end
    end
  end

  describe "DELETE #destroy" do
    context 'with logged in admin and valid order' do

      let(:admin) { create(:admin) }

      before do
        test_sign_in(admin, false)
        @cart = create(:cart)
        @order = create(:order, cart: @cart, express_token: nil)
        session[:cart_id] = @cart.id
      end

      it "destroys the requested order" do
        expect { delete :destroy, {id: @order} }.to change { Order.count }.by(-1)
      end

      it "destroys the associated cart" do
        expect { delete :destroy, {id: @order} }.to change{ Cart.count }.by(-1)
      end

      it "destroys the associated line_item" do
        product = create(:product)
        option = create(:option, product: product)
        create(:line_item, cart: @cart, product: product, option: option)
        expect { delete :destroy, {id: @order} }.to change{ LineItem.count }.by(-1)
      end

      it "destroys the associated transaction" do
        create(:transaction, order: @order)
        expect { delete :destroy, {id: @order} }.to change{ Transaction.count }.by(-1)
      end

      it "destroys the associated addresses" do
        create(:address, address_type: 'billing', addressable: @order)
        create(:address, address_type: 'shipping', addressable: @order)
        expect { delete :destroy, {id: @order} }.to change{ Address.count }.by(-2)
      end

      it "does not destroy the associated product" do
        product = create(:product)
        option = create(:option, product: product)
        create(:line_item, cart: @cart, product: product, option: option)
        expect { delete :destroy, {id: @order} }.not_to change{ Product.count }
      end

      it "does not destroy the associated option" do
        product = create(:product)
        option = create(:option, product: product)
        create(:line_item, cart: @cart, product: product, option: option)
        expect { delete :destroy, {id: @order} }.not_to change{ Option.count }
      end

      it "redirects to the orders list" do
        delete :destroy, {id: @order}
        expect(response).to redirect_to(orders_path)
      end
    end

    context 'as a guest' do
      before do
        @cart = create(:cart)
        @order = create(:order, cart: @cart, express_token: nil)
        session[:cart_id] = @cart.id
        delete :destroy, {id: @order}
      end
      it 'redirects to home page' do
        expect(response).to redirect_to home_path
      end
      it 'sets the flash' do
        expect(flash[:alert]).to eq 'Sorry, admins only'
      end
    end
  end

  describe "GET #delete_abandoned" do
    context 'with logged in admin and valid order' do

      let(:admin) { create(:admin) }

      before do
        test_sign_in(admin, false)
        @cart = create(:cart)
        @order = create(:order, cart: @cart, express_token: nil)
        session[:cart_id] = @cart.id
      end

      it "does not destroy a completed order" do
        create(:address, address_type: 'billing', addressable: @order)
        create(:address, address_type: 'shipping', addressable: @order)
        create(:transaction, order: @order)
        expect { get :delete_abandoned }.not_to change{ Order.count }
      end

      it "destroys orders without email" do
        @order.update(email: nil)
        create(:address, address_type: 'billing', addressable: @order)
        create(:address, address_type: 'shipping', addressable: @order)
        create(:transaction, order: @order)
        expect { get :delete_abandoned }.to change{ Order.count }.by(-1)
      end

      it "destroys orders without billing address" do
        create(:address, address_type: 'shipping', addressable: @order)
        create(:transaction, order: @order)
        expect { get :delete_abandoned }.to change{ Order.count }.by(-1)
      end

      it "destroys orders without shipping address" do
        create(:address, address_type: 'billing', addressable: @order)
        create(:transaction, order: @order)
        expect { get :delete_abandoned }.to change{ Order.count }.by(-1)
      end

      it "destroys orders without cart" do
        @order.update(cart: nil)
        create(:address, address_type: 'billing', addressable: @order)
        create(:address, address_type: 'shipping', addressable: @order)
        create(:transaction, order: @order)
        expect { get :delete_abandoned }.to change{ Order.count }.by(-1)
      end

      it "destroys orders without transaction" do
        create(:address, address_type: 'billing', addressable: @order)
        create(:address, address_type: 'shipping', addressable: @order)
        expect { get :delete_abandoned }.to change{ Order.count }.by(-1)
      end
    end

    context 'as a guest' do
      before do
        @cart = create(:cart)
        @order = create(:order, cart: @cart, express_token: nil)
        session[:cart_id] = @cart.id
        get :delete_abandoned, id: @order
      end
      it 'redirects to home page' do
        expect(response).to redirect_to home_path
      end
      it 'sets the flash' do
        expect(flash[:alert]).to eq 'Sorry, admins only'
      end
    end
  end
end