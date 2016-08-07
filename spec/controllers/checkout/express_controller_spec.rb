require 'rails_helper'

describe Checkout::ExpressController do
  describe "GET #new" do
    context 'as a guest with addressable order', :vcr do
      before do
        cart = create(:cart)
        product = create(:product)
        option = create(:option, product: product)
        create(:line_item, cart: cart, product: product, option: option)
        create(:order, cart: cart, express_token: nil)
        session[:cart_id] = cart.id
        get :new, checkout_id: cart
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'responds with content type html' do
        expect(response.content_type).to eq('text/html')
      end
      it 'redirects to Paypal' do
        expect(response).to redirect_to("https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-9TY08414RW333532Y")
      end
    end

    context 'as a guest with unaddressable order' do
      before do
        cart = create(:cart)
        create(:order, cart: cart, express_token: nil)
        session[:cart_id] = cart.id
        get :new, checkout_id: cart
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to products path' do
        expect(response).to redirect_to products_path
      end
    end
  end

  describe "GET #edit" do
    context 'as a guest with addressable order', :vcr do
      before do
        @cart = create(:cart)
        product = create(:product)
        option = create(:option, product: product)
        create(:line_item, cart: @cart, product: product, option: option)
        create(:order, cart: @cart, express_token: 'EC-9TY08414RW333532Y')
        session[:cart_id] = @cart.id
        get :edit, checkout_id: @cart, token: 'EC-9TY08414RW333532Y'
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'responds with content type html' do
        expect(response.content_type).to eq('text/html')
      end
      it 'redirects to new_checkout_shipping_path' do
        expect(response).to redirect_to(new_checkout_shipping_path(@cart))
      end
    end

    context 'as a guest with unaddressable order' do
      before do
        cart = create(:cart)
        create(:order, cart: cart, express_token: nil)
        session[:cart_id] = cart.id
        get :edit, checkout_id: cart
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to products path' do
        expect(response).to redirect_to products_path
      end
    end
  end
end