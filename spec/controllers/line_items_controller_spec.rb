require 'rails_helper'

describe LineItemsController do

  let!(:cart)           { create(:cart) }
  let!(:product)        { create(:product) }
  let!(:option)         { create(:option, product: product) }
  let(:valid_params)    { attributes_for(:line_item, cart: cart, product: product, option: option) }
  let(:invalid_params)  { attributes_for(:line_item, cart: nil, product: product, option: option) }

  before { test_sign_out(false) }

  describe "POST #create" do
    describe "with valid params" do
      it "creates a new LineItem" do
        session[:cart_id] = cart.id
        expect {
          post :create, { line_item: valid_params, format: 'js', product_id: product.to_param, option_id: option.to_param }
        }.to change(LineItem, :count).by(1)
      end

      it "creates a new cart if none exists" do
        session[:cart_id] = nil
        expect {
          post :create, { line_item: valid_params, format: 'js', product_id: product.to_param, option_id: option.to_param }
          }.to change(Cart, :count).by(1)
      end

      it "attaches a newly created LineItem to cart" do
        session[:cart_id] = cart.id
        post :create, { line_item: valid_params, format: 'js', product_id: product.to_param, option_id: option.to_param }
        expect(cart.line_items.last).to eq(LineItem.last)
      end

      it "triggers an alert" do
        post :create, { line_item: valid_params, format: 'js', product_id: product.to_param, option_id: option.to_param }
        expect(response).to render_template("create")
      end

      it "redirects to product index without 'js' format" do
        post :create, { line_item: valid_params, product_id: product.to_param, option_id: option.to_param }
        expect(response).to redirect_to(products_path)
      end
    end

    describe "with invalid params" do
      it "redirects to products index with bad product.id" do
        post :create, { line_item: valid_params, format: 'js', product_id: nil, option_id: option.to_param }
        expect(response).to redirect_to(products_path)
      end

      it "redirects to products index with bad option.id" do
        post :create, { line_item: valid_params, format: 'js', product_id: product.to_param, option_id: nil }
        expect(response).to redirect_to(products_path)
      end
    end
  end
end
