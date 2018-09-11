require 'rails_helper'

describe Checkout::AddressesController do
  describe "GET #new" do
    context 'as a guest with empty cart' do
      before do
        allow_any_instance_of(Checkout::AddressesController)
          .to receive_message_chain(:cart, :line_items_empty?)
          .and_return(true)
        get new_checkout_address_path(0)
      end
      it 'redirects to products path' do
        expect(response).to redirect_to products_path
      end
      it 'sets flash notice' do
        expect(flash[:notice]).to eq('Your cart is empty')
      end
    end

    context 'as a guest with purchased cart' do
      before do
        allow_any_instance_of(Checkout::AddressesController)
          .to receive_message_chain(:cart, :line_items_empty?)
          .and_return(false)
        allow_any_instance_of(Checkout::AddressesController)
          .to receive_message_chain(:cart, :purchased?)
          .and_return(true)
        get new_checkout_address_path(0)
      end
      it 'redirects to products path' do
        expect(response).to redirect_to products_path
      end
      it 'sets flash notice' do
        expect(flash[:notice]).to eq('Cart already purchased')
      end
    end

    context 'as a guest with cart in bad state' do
      before do
        allow_any_instance_of(Checkout::AddressesController)
          .to receive_message_chain(:cart, :line_items_empty?)
          .and_return(false)
        allow_any_instance_of(Checkout::AddressesController)
          .to receive_message_chain(:cart, :purchased?)
          .and_return(false)
        allow_any_instance_of(Checkout::AddressesController)
          .to receive_message_chain(:order, :addressable?)
          .and_return(false)
        get new_checkout_address_path(0)
      end
      it 'redirects to products path' do
        expect(response).to redirect_to products_path
      end
      it 'sets flash notice' do
        expect(flash[:alert]).to eq('Sorry, unable to continue checkout.')
      end
    end

    context 'as a guest with addressable order' do
      before do
        product = create(:product)
        option = create(:option, product: product)
        post line_items_path,
          params: { itemizable_type: option.class.name, itemizable_id: option.id }
        get new_checkout_address_path(Cart.last)
      end
      it 'responds successfully' do
        expect(response).to be_successful
      end
      it 'responds with content type html' do
        expect(response.content_type).to eq('text/html')
      end
    end

    context 'signed in user with addresses' do
      let(:billing) { create(:billing) }
      let(:shipping) { create(:shipping) }
      let(:user) { create(:user, addresses: [billing, shipping]) }
      before do
        test_sign_in(user, use_capybara: false)
        product = create(:product)
        option = create(:option, product: product)
        post line_items_path,
          params: { itemizable_type: option.class.name, itemizable_id: option.id }
        get new_checkout_address_path(Cart.last)
      end
      it 'populates form with user addresses' do
        expect(response.body).to include(user.addresses.billing_address.address_1)
        expect(response.body).to include(user.addresses.shipping_address.address_1)
      end
    end

    context 'signed in user without addresses' do
      let(:user) { create(:user) }
      before do
        test_sign_in(user, use_capybara: false)
        product = create(:product)
        option = create(:option, product: product)
        post line_items_path,
          params: { itemizable_type: option.class.name, itemizable_id: option.id }
        get new_checkout_address_path(Cart.last)
      end
      it 'creates new order.address record' do
        expect(response.body).to include('id="order_addresses_attributes_0_address_1" /></td>')
        expect(response.body).to include('id="order_addresses_attributes_1_address_1" /></td>')
      end
    end
  end

  describe "POST #create" do
    before do
      product = create(:product)
      tag = create(:size_weight_price_tag)
      component = create(:component, size_weight_price_tag: tag)
      option = create(:option, product: product, component: component)
      post line_items_path,
        params: { itemizable_type: option.class.name, itemizable_id: option.id }
      @cart = Cart.last
      get new_checkout_address_path(@cart)
    end

    context 'as a guest with valid addresses' do
      before do
        valid_address = attributes_for(:address)
        post checkout_addresses_path(@cart),
          params: {
            order: {
              addresses_attributes: { "0" => valid_address, "1" => valid_address }
            }
          }
      end
      it 'redirects to products path' do
        expect(response).to redirect_to new_checkout_shipping_path(@cart)
      end
      it 'sets flash success' do
        expect(flash[:success]).to eq('Addresses saved!')
      end
    end

    context 'copy billing address to shipping address' do
      before do
        valid_address = attributes_for(:address)
        post checkout_addresses_path(@cart),
          params: {
            order: {
              use_billing: 'yes',
              addresses_attributes: { "0" => valid_address }
            }
          }
      end
      it 'copies the address' do
        expect(@cart.order.addresses.billing_address.address_1).to eq(@cart.order.addresses.shipping_address.address_1)
      end
      it 'redirects to products path' do
        expect(response).to redirect_to new_checkout_shipping_path(@cart)
      end
      it 'sets flash success' do
        expect(flash[:success]).to eq('Addresses saved!')
      end
    end

    context 'as a guest with invalid addresses' do
      before do
        invalid_address = attributes_for(:address, first_name: nil)
        post checkout_addresses_path(@cart), params: {
          order: { addresses_attributes:
            { "0" => invalid_address, "1" => invalid_address }
          }
        }
      end
      it 'responds with status :ok' do
        expect(response).to be_successful
      end
      it 'displays validation errors' do
        expect(response.body).to include('There are 1 error on the page')
      end
    end
  end
end

