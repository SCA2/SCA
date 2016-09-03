require 'rails_helper'

describe Checkout::TransactionsController do
  describe "GET #new" do
    before do
      @cart = create(:cart)
      product = create(:n72)
      option = create(:ka, product: product)
      bom = create(:bom, option: option)
      create(:bom_item, bom: bom)
      create(:line_item, cart: @cart, product: product, option: option)
      @order = create(:order, cart: @cart, express_token: nil)
      create(:billing_constant_taxable, addressable: @order)
      create(:shipping_constant_taxable, addressable: @order)
      create(:transaction, order: @order)
      session[:cart_id] = @cart.id
    end

    context 'as a guest with successful order' do
      before do
        get :new, checkout_id: @cart, success: 'true'
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
      it 'renders the success template' do
        expect(response).to render_template(:success)
      end
    end

    context 'as a guest with unsuccessful order' do
      before do
        get :new, checkout_id: @cart, success: 'false'
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
        expect(response).to render_template(:failure)
      end
    end

    context 'as a guest with un-notifiable order' do
      before do
        @order.update(email: nil)
        get :new, checkout_id: @cart, success: true
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to products path' do
        expect(response).to redirect_to new_checkout_payment_path(@order)
      end
    end
  end
end
