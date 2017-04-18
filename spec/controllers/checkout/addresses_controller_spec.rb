require 'rails_helper'

describe Checkout::AddressesController do
  describe "GET #new" do
    context 'as a guest with addressable order' do
      before do
        cart = create(:cart)
        product = create(:product)
        option = create(:option, product: product)
        create(:line_item, cart: cart, product: product, option: option)
        create(:order, cart: cart, express_token: nil)
        session[:cart_id] = cart.id
        get :new, params: { checkout_id: cart }
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

    context 'as a guest with unaddressable order' do
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
  end

  describe "POST #create" do
    context 'as a guest with valid addresses' do
      before do
        @cart = create(:cart)
        product = create(:product)
        option = create(:option, product: product)
        create(:line_item, cart: @cart, product: product, option: option)
        create(:order, cart: @cart, express_token: nil)
        session[:cart_id] = @cart.id
        valid_address = attributes_for(:address)
        post :create, params: {
          checkout_id: @cart,
          order: { addresses_attributes:
            { "0" => valid_address, "1" => valid_address }
          }
        }
      end
      it 'responds with status :redirect' do
        expect(response).to have_http_status :redirect
      end
      it 'redirects to products path' do
        expect(response).to redirect_to new_checkout_shipping_path(@cart)
      end
    end

    context 'as a guest with invalid addresses' do
      before do
        cart = create(:cart)
        product = create(:product)
        option = create(:option, product: product)
        create(:line_item, cart: cart, product: product, option: option)
        create(:order, cart: cart, express_token: nil)
        session[:cart_id] = cart.id
        invalid_address = attributes_for(:address, first_name: nil)
        post :create, params: {
          checkout_id: cart,
          order: { addresses_attributes:
            { "0" => invalid_address, "1" => invalid_address }
          }
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
  end
end