require 'rails_helper'

describe Checkout::PaymentController do
  describe "GET #new" do
    context 'as a guest with confirmed order' do
      before do
        cart = create(:cart)
        product = create(:n72)
        option = create(:ka, product: product)
        create(:line_item, cart: cart, product: product, option: option)
        order = create(:order,
          cart: cart,
          express_token: nil,
        )
        create(:billing_constant_taxable, addressable: order)
        create(:shipping_constant_taxable, addressable: order)
        session[:cart_id] = cart.id
        get :new, checkout_id: cart.id, accept_terms: true
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
      it 'renders the new template' do
        expect(response).to render_template(:new)
      end
    end

    context 'as a guest with unconfirmable order' do
      before do
        @cart = create(:cart)
        product = create(:n72)
        option = create(:ka, product: product)
        create(:line_item, cart: @cart, product: product, option: option)
        order = create(:order,
          cart: @cart,
          express_token: nil,
          shipping_cost: nil
        )
        create(:billing_constant_taxable, addressable: order)
        create(:shipping_constant_taxable, addressable: order)
        session[:cart_id] = @cart.id
        get :new, checkout_id: @cart.id, accept_terms: true
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to products path' do
        expect(response).to redirect_to new_checkout_confirmation_path(@cart)
      end
    end
  end

  describe "POST #update" do
    context 'as a guest with confirmed order', :vcr do
      before do
        @cart = create(:cart)
        product = create(:n72)
        option = create(:ka, product: product)
        create(:line_item, cart: @cart, product: product, option: option)
        order = create(:order, cart: @cart, express_token: nil)
        create(:billing_constant_taxable, addressable: order)
        create(:shipping_constant_taxable, addressable: order)
        session[:cart_id] = @cart.id
        post :create,
          checkout_id: @cart.id,
          card_validator: {
            card_type: 'Visa',
            card_number: '4032034105891439',
            card_expires_on: '06-2021',
            card_verification: '123',
            email: 'sales-buyer-2@seventhcircleaudio.com'
          }
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to payment path' do
        expect(response).to redirect_to new_checkout_transaction_path(@cart, success: true)
      end
    end

    context 'as a guest with unconfirmable order', :vcr do
      before do
        @cart = create(:cart)
        product = create(:n72)
        option = create(:ka, product: product)
        create(:line_item, cart: @cart, product: product, option: option)
        order = create(:order, cart: @cart, express_token: nil, shipping_cost: nil)
        session[:cart_id] = @cart.id
        post :create,
          checkout_id: @cart.id,
          card_validator: {
            card_type: 'Visa',
            card_number: '4032034105891439',
            card_expires_on: '06-2021',
            card_verification: '123',
            email: 'sales-buyer-2@seventhcircleaudio.com'
          }
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to payment path' do
        expect(response).to redirect_to new_checkout_confirmation_path(@cart)
      end
    end

    context 'as a guest with invalid payment details' do
      before do
        @cart = create(:cart)
        product = create(:n72)
        option = create(:ka, product: product)
        create(:line_item, cart: @cart, product: product, option: option)
        order = create(:order, cart: @cart, express_token: nil)
        create(:billing_constant_taxable, addressable: order)
        create(:shipping_constant_taxable, addressable: order)
        session[:cart_id] = @cart.id
        post :create,
          checkout_id: @cart.id,
          card_validator: {
            card_type: 'Visa',
            card_number: '',
            card_expires_on: '06-2021',
            card_verification: '123',
            email: 'sales-buyer-2@seventhcircleaudio.com'
          }
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
      it 'renders the new template' do
        expect(response).to render_template(:new)
      end
    end

    context 'as a guest with failed purchase', :vcr do
      before do
        @cart = create(:cart)
        product = create(:n72)
        option = create(:ka, product: product)
        create(:line_item, cart: @cart, product: product, option: option)
        order = create(:order, cart: @cart, express_token: nil)
        create(:billing_constant_taxable, addressable: order)
        create(:shipping_constant_taxable, addressable: order)
        session[:cart_id] = @cart.id
        post :create,
          checkout_id: @cart.id,
          card_validator: {
            card_type: 'Visa',
            card_number: '4032038036005571',
            card_expires_on: '12-2019',
            card_verification: '123',
            email: 'sales-buyer@seventhcircleaudio.com'
          }
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to payment path' do
        expect(response).to redirect_to new_checkout_transaction_path(@cart, success: false)
      end
    end
  end
end