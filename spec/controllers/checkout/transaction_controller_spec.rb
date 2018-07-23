require 'rails_helper'

describe Checkout::TransactionsController do
  describe "GET #new" do
    before do
      @cart = create(:cart)
      product = create(:n72)
      option = create(:ka, product: product)
      bom = create(:bom, option: option)
      create(:bom_item, bom: bom)
      create(:line_item, cart: @cart, option: option)
      session[:cart_id] = @cart.id
      session[:progress] = 'current_path'
    end

    context 'as a guest with successful order purchase' do
      before do
        order = create(:order, cart: @cart, stripe_token: 'good_token', express_token: nil, confirmed: true)
        create(:billing_constant_taxable, addressable: order)
        create(:shipping_constant_taxable, addressable: order)
        create(:transaction, order: order)
        class_double("OrderPurchaser", new: instance_double("OrderPurchaser", purchase: true)).as_stubbed_const
        get :new, params: { checkout_id: @cart }
      end
      
      it 'responds with status :ok' do
        expect(response).to have_http_status :ok
      end
      it 'responds with content type html' do
        expect(response.content_type).to eq('text/html')
      end
      it 'sets the success flash' do
        expect(flash[:success]).to eq('Thank you for your order!')
      end
      it 'sets the session cart_id to nil' do
        expect(session.keys).to include('cart_id')
        expect(session[:cart_id]).to eq(nil)
      end
      it 'sets the session checkout progress to []' do
        expect(session.keys).to include('progress')
        expect(session[:progress]).to eq([])
      end
    end

    context 'as a guest with unsuccessful order purchase' do
      before do
        order = create(:order, cart: @cart, stripe_token: 'bad_token', express_token: nil, confirmed: true)
        create(:billing_constant_taxable, addressable: order)
        create(:shipping_constant_taxable, addressable: order)
        create(:transaction, order: order)
        class_double("OrderPurchaser", new: instance_double("OrderPurchaser", purchase: false)).as_stubbed_const
        get :new, params: { checkout_id: @cart }
      end

      it 'responds with status :ok' do
        expect(response).to have_http_status :ok
      end
      it 'responds with content type html' do
        expect(response.content_type).to eq('text/html')
      end
      it 'sets the success flash' do
        expect(flash[:alert]).to eq('Sorry, we had a problem with your credit card payment.')
      end
      it 'saves the session cart_id' do
        expect(session.keys).to include('cart_id')
        expect(session[:cart_id]).to eq(@cart.id)
      end
      it 'sets the session checkout progress to []' do
        expect(session.keys).to include('progress')
        expect(session[:progress]).to eq([])
      end
    end

    context 'as a guest with unconfirmed order' do
      before do
        @order = create(:order, cart: @cart, stripe_token: 'good_token', express_token: nil, email: nil)
        create(:billing_constant_taxable, addressable: @order)
        create(:shipping_constant_taxable, addressable: @order)
        create(:transaction, order: @order)
        class_double("OrderPurchaser", new: instance_double("OrderPurchaser", purchase: false)).as_stubbed_const
        get :new, params: { checkout_id: @cart }
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to checkout confirmation path' do
        expect(response).to redirect_to new_checkout_confirmation_path(@order)
      end
    end
  end
end
