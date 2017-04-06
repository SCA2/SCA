require 'rails_helper'

describe Checkout::TransactionsController do

  let(:good_token) do
    Stripe::Token.create(
      card: {
        number: "4242424242424242",
        exp_month: Date.today.month,
        exp_year: Date.today.next_year.year,
        cvc: 314
      }
    ).id
  end

  let(:bad_token) do
    Stripe::Token.create(
      card: {
        number: "4000000000000002",
        exp_month: Date.today.month,
        exp_year: Date.today.next_year.year,
        cvc: 314
      }
    ).id
  end

  describe "GET #new" do
    before do
      @cart = create(:cart)
      product = create(:n72)
      option = create(:ka, product: product)
      bom = create(:bom, option: option)
      create(:bom_item, bom: bom)
      create(:line_item, cart: @cart, product: product, option: option)
    end

    context 'as a guest with successful order' do
      before do
        @order = create(:order, cart: @cart, stripe_token: good_token, express_token: nil)
        create(:billing_constant_taxable, addressable: @order)
        create(:shipping_constant_taxable, addressable: @order)
        create(:transaction, order: @order)
        session[:cart_id] = @cart.id
        get :new, checkout_id: @cart, accept_terms: '1'
      end
      
      it 'responds with status :ok', :vcr do
        expect(response).to have_http_status :ok
      end
      it 'responds with content type html', :vcr do
        expect(response.content_type).to eq('text/html')
      end
      it 'renders the application layout', :vcr do
        expect(response).to render_template(layout: 'layouts/application')
      end
      it 'renders the success template', :vcr do
        expect(response).to render_template(:success)
      end
    end

    context 'as a guest with unsuccessful order' do
      before do
        @order = create(:order, cart: @cart, stripe_token: bad_token, express_token: nil)
        create(:billing_constant_taxable, addressable: @order)
        create(:shipping_constant_taxable, addressable: @order)
        create(:transaction, order: @order)
        session[:cart_id] = @cart.id
        get :new, checkout_id: @cart, success: 'false', accept_terms: '1'
      end

      it 'responds with status :ok', :vcr do
        expect(response).to have_http_status :ok
      end
      it 'responds with content type html', :vcr do
        expect(response.content_type).to eq('text/html')
      end
      it 'renders the application layout', :vcr do
        expect(response).to render_template(layout: 'layouts/application')
      end
      it 'renders the new template', :vcr do
        expect(response).to render_template(:failure)
      end
    end

    context 'as a guest with un-transactable order' do
      before do
        @order = create(:order, cart: @cart, stripe_token: good_token, express_token: nil, email: nil)
        create(:billing_constant_taxable, addressable: @order)
        create(:shipping_constant_taxable, addressable: @order)
        create(:transaction, order: @order)
        session[:cart_id] = @cart.id
        get :new, checkout_id: @cart, accept_terms: '1'
      end
      it 'responds with status :redirect', :vcr do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to checkout confirmation path', :vcr do
        expect(response).to redirect_to new_checkout_confirmation_path(@order)
      end
    end
  end
end
