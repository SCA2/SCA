require 'rails_helper'

describe Checkout::ConfirmationController do
  describe "GET #new" do
    context 'as a guest with confirmable order', :vcr do
      before do
        cart = create(:cart)
        product = create(:n72)
        option = create(:ka, product: product)
        create(:line_item, cart: cart, product: product, option: option)
        order = create(:order, cart: cart, express_token: nil)
        create(:billing_constant_taxable, addressable: order)
        create(:shipping_constant_taxable, addressable: order)
        session[:cart_id] = cart.id
        get :new, checkout_id: cart
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

    context 'as a guest with unconfirmable order', :vcr do
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
        get :new, checkout_id: @cart.id
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to products path' do
        expect(response).to redirect_to new_checkout_shipping_path(@cart)
      end
    end
  end

  describe "POST #update" do
    context 'as a guest with confirmable order' do
      before do
        @cart = create(:cart)
        product = create(:n72)
        option = create(:ka, product: product)
        create(:line_item, cart: @cart, product: product, option: option)
        order = create(:order, cart: @cart, express_token: nil)
        create(:billing_constant_taxable, addressable: order)
        create(:shipping_constant_taxable, addressable: order)
        session[:cart_id] = @cart.id
        post :update,
          checkout_id: @cart.id,
          order: { terms_validator: { accept_terms: '1' }}
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to payment path' do
        expect(response).to redirect_to new_checkout_payment_path(@cart, accept_terms: '1')
      end
    end

    context 'as a guest with confirmable paypal express order', :vcr do
      before do
        @cart = create(:cart)
        product = create(:n72)
        option = create(:ka, product: product)
        create(:line_item, cart: @cart, product: product, option: option)
        order = create(:order, cart: @cart, express_token: 'token')
        create(:billing_constant_taxable, addressable: order)
        create(:shipping_constant_taxable, addressable: order)
        session[:cart_id] = @cart.id
        post :update,
          checkout_id: @cart.id,
          order: { terms_validator: { accept_terms: '1' }}
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to payment path' do
        expect(response).to redirect_to edit_checkout_payment_path(@cart)
      end
    end

    context 'as a guest with unconfirmable order' do
      before do
        @cart = create(:cart)
        product = create(:n72)
        option = create(:ka, product: product)
        create(:line_item, cart: @cart, product: product, option: option)
        order = create(:order, cart: @cart, express_token: nil)
        create(:billing_constant_taxable, addressable: order)
        session[:cart_id] = @cart.id
        post :update,
          checkout_id: @cart.id,
          order: { terms_validator: { accept_terms: '1' }}
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to products path' do
        expect(response).to redirect_to new_checkout_confirmation_path(@cart)
      end
    end

    context 'as a guest without confirmation' do
      before do
        @cart = create(:cart)
        product = create(:n72)
        option = create(:ka, product: product)
        create(:line_item, cart: @cart, product: product, option: option)
        order = create(:order, cart: @cart, express_token: nil)
        create(:billing_constant_taxable, addressable: order)
        create(:shipping_constant_taxable, addressable: order)
        session[:cart_id] = @cart.id
        post :update,
          checkout_id: @cart.id,
          order: { terms_validator: { accept_terms: '0' }}
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to products path' do
        expect(response).to redirect_to new_checkout_confirmation_path(@cart)
      end
      it 'displays flash alert' do
        expect(flash[:alert]).to eq('You must accept terms to proceed!')
      end
    end
  end
end