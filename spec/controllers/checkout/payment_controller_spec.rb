require 'rails_helper'

describe Checkout::PaymentController do
  describe "GET #new" do
    context 'as a guest with payable order' do
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
        get :new, params: { checkout_id: cart.id }
      end
      it 'responds with status :ok' do
        expect(response).to have_http_status :ok
      end
      it 'responds with content type html' do
        expect(response.content_type).to eq('text/html')
      end
    end

    context 'as a guest with unpayable order' do
      before do
        @cart = create(:cart)
        product = create(:n72)
        option = create(:ka, product: product)
        create(:line_item, cart: @cart, product: product, option: option)
        order = create(:order,
          cart: @cart,
          shipping_cost: nil
        )
        create(:billing_constant_taxable, addressable: order)
        create(:shipping_constant_taxable, addressable: order)
        session[:cart_id] = @cart.id
        get :new, params: { checkout_id: @cart.id }
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to checkout shipping path' do
        expect(response).to redirect_to new_checkout_shipping_path(@cart)
      end
    end
  end

  describe "POST #update" do
    context 'as a guest with confirmed order' do
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
          card_tokenizer: {
            stripe_token: 'token',
            email: 'sales-buyer-2@seventhcircleaudio.com'
          }
        }
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to payment path' do
        expect(response).to redirect_to new_checkout_confirmation_path(@cart)
      end
    end

    context 'as a guest with unpayable order' do
      before do
        @cart = create(:cart)
        product = create(:n72)
        option = create(:ka, product: product)
        create(:line_item, cart: @cart, product: product, option: option)
        create(:order, cart: @cart, express_token: nil, shipping_cost: nil)
        session[:cart_id] = @cart.id
        post :update, params: {
          checkout_id: @cart.id,
          card_tokenizer: {
            stripe_token: 'token',
            email: 'sales-buyer-2@seventhcircleaudio.com'
          }
        }
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to payment path' do
        expect(response).to redirect_to new_checkout_shipping_path(@cart)
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
        post :update, params: {
          checkout_id: @cart.id,
          card_tokenizer: {
            stripe_token: nil,
            email: 'sales-buyer-2@seventhcircleaudio.com'
          }
        }
      end
      it 'responds with status :ok' do
        expect(response).to have_http_status :ok
      end
      it 'responds with content type html' do
        expect(response.content_type).to eq('text/html')
      end
    end

    context 'as a guest with failed purchase' do
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
          card_tokenizer: {
            stripe_token: 'bad_token',
            email: 'sales-buyer@seventhcircleaudio.com'
          }
        }
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to payment path' do
        expect(response).to redirect_to new_checkout_confirmation_path(@cart)
      end
    end
  end
end