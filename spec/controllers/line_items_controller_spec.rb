require 'rails_helper'

describe LineItemsController do

  let!(:cart)           { create(:cart) }
  let!(:product)        { create(:product) }
  let!(:option)         { create(:option, product: product) }
  let(:valid_params)    { attributes_for(:line_item, cart: cart, option: option) }
  let(:invalid_params)  { attributes_for(:line_item, cart: nil, option: option) }

  before { test_sign_out(use_capybara: false) }

  describe "POST #create" do
    describe "with valid params" do
      it "creates a new LineItem" do
        session[:cart_id] = cart.id
        expect {
          post :create, params: {
            line_item: valid_params,
            format: 'js',
            option_id: option.to_param
          }
        }.to change(LineItem, :count).by(1)
      end

      it "creates a new cart if none exists" do
        session[:cart_id] = nil
        expect {
          post :create, params: {
            line_item: valid_params,
            format: 'js',
            option_id: option.to_param
          }
        }.to change(Cart, :count).by(1)
      end

      it "attaches a newly created LineItem to cart" do
        session[:cart_id] = cart.id
        post :create, params: {
          line_item: valid_params,
          format: 'js',
          option_id: option.to_param
        }

        expect(cart.line_items.last).to eq(LineItem.last)
      end

      it "redirects to product index without 'js' format" do
        post :create, params: {
          line_item: valid_params,
          option_id: option.to_param
        }

        expect(response).to redirect_to(products_path)
      end
    end

    describe "with invalid params" do
      it "redirects to products index with bad option.id" do
        post :create, params: {
          line_item: valid_params,
          format: 'js',
          product_id: product.to_param, option_id: nil
        }

        expect(response).to redirect_to(products_path)
      end
    end
  end
end
