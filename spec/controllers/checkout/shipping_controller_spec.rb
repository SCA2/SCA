require 'rails_helper'

describe Checkout::ShippingController do
  describe "GET #new" do
    context 'as a guest with shippable order', :vcr do
      before do
        cart = create(:cart)
        product = create(:n72)
        option = create(:ka, product: product)
        create(:line_item, cart: cart, product: product, option: option)
        order = create(:order, cart: cart, express_token: nil)
        create(:billing_constant_taxable, addressable: order)
        create(:shipping_constant_taxable, addressable: order)
        session[:cart_id] = cart.id
        get :new, params: { checkout_id: cart }
      end
      it 'responds with status :ok' do
        expect(response).to have_http_status :ok
      end
      it 'responds with content type html' do
        expect(response.content_type).to eq('text/html')
      end
    end

    context 'as a guest with unshippable order', :vcr do
      before do
        cart = create(:cart)
        create(:order, cart: cart, express_token: nil)
        session[:cart_id] = cart.id
        get :new, params: { checkout_id: cart }
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to products path' do
        expect(response).to redirect_to products_path
      end
    end

    context 'as a guest with invalid address', :vcr do
      before do
        @cart = create(:cart)
        product = create(:n72)
        option = create(:ka, product: product)
        create(:line_item, cart: @cart, product: product, option: option)
        order = create(:order, cart: @cart, express_token: nil)
        create(:invalid_billing_zip, addressable: order)
        create(:invalid_shipping_zip, addressable: order)
        session[:cart_id] = @cart.id
        get :new, params: { checkout_id: @cart }
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to products path' do
        expect(response).to redirect_to new_checkout_address_path(@cart)
      end
    end
  end

  describe "POST #update" do
    context 'as a guest with shippable order', :vcr do
      before do
        @cart = create(:cart)
        product = create(:n72)
        option = create(:ka, product: product)
        create(:line_item, cart: @cart, product: product, option: option)
        order = create(:order, cart: @cart, express_token: nil)
        create(:billing_constant_taxable, addressable: order)
        create(:shipping_constant_taxable, addressable: order)
        session[:cart_id] = @cart.id
        post :update, params: {
          checkout_id: @cart.id,
          order: { shipping_method: "USPS Priority Mail 1-Day, 670" }
        }
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to products path' do
        expect(response).to redirect_to new_checkout_payment_path(@cart)
      end
    end

    context 'as a guest with unshippable order', :vcr do
      before do
        @cart = create(:cart)
        product = create(:n72)
        option = create(:ka, product: product)
        create(:line_item, cart: @cart, product: product, option: option)
        order = create(:order, cart: @cart, express_token: nil)
        create(:billing_constant_taxable, addressable: order)
        session[:cart_id] = @cart.id
        post :update, params: {
          checkout_id: @cart.id,
          order: { shipping_method: "USPS Priority Mail 1-Day, 670" }
        }
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to products path' do
        expect(response).to redirect_to new_checkout_address_path(@cart)
      end
    end

    context 'as a guest with missing shipping method', :vcr do
      before do
        @cart = create(:cart)
        product = create(:n72)
        option = create(:ka, product: product)
        create(:line_item, cart: @cart, product: product, option: option)
        order = create(:order, cart: @cart, express_token: nil)
        create(:billing_constant_taxable, addressable: order)
        create(:shipping_constant_taxable, addressable: order)
        session[:cart_id] = @cart.id
        post :update, params: {
          checkout_id: @cart.id,
          order: { shipping_method: "" }
        }
      end
      it 'responds with status :ok' do
        expect(response).to have_http_status :ok
      end
      it 'responds with content type html' do
        expect(response.content_type).to eq('text/html')
      end
      it 'displays flash alert' do
        expect(flash[:alert]).to eq('Please select a shipping method!')
      end
    end
  end
end