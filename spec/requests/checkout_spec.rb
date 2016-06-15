require 'rails_helper'

describe OrdersController do

  context 'admin access' do

    let(:admin) { create(:admin) }
    before { test_sign_in(admin, false) }

    describe "GET #index", :vcr do
      it "assigns all orders as @orders" do
        order = create(:order)
        get :index, {}
        expect(assigns(:orders)).to eq([order])
      end

      it "renders the index" do
        order = create(:order)
        get :index, {}
        expect(response).to render_template(:index)
      end
    end

    describe "GET #show", :vcr do
      it "assigns the requested order as @order" do
        order = create(:order)
        get :show, {id: order}
        expect(assigns(:order)).to eq(order)
      end

      it "renders a valid order" do
        cart = create(:cart)
        order = create(:order, cart: cart)
        create(:address, address_type: 'billing', addressable: order)
        create(:address, address_type: 'shipping', addressable: order)
        get :show, {id: order}
        expect(response).to render_template(:show)
      end

      it "redirects with an invalid order" do
        cart = create(:cart)
        order = create(:order, cart: cart)
        create(:address, address_type: 'billing', addressable: order)
        get :show, {id: order}
        expect(response).to redirect_to(orders_path)
      end
    end

    describe "DELETE #destroy", :vcr do
      let!(:cart) { create(:cart) }
      let!(:order) { create(:order, cart: cart) }

      it "destroys the requested order" do
        session[:cart_id] = cart.id
        expect { delete :destroy, {id: order} }.to change { Order.count }.by(-1)
      end

      it "destroys the associated cart" do
        session[:cart_id] = cart.id
        expect { delete :destroy, {id: order} }.to change{ Cart.count }.by(-1)
      end

      it "destroys the associated line_item" do
        session[:cart_id] = cart.id
        product = create(:product)
        option = create(:option, product: product)
        create(:line_item, cart: cart, product: product, option: option)
        expect { delete :destroy, {id: order} }.to change{ LineItem.count }.by(-1)
      end

      it "destroys the associated transaction" do
        session[:cart_id] = cart.id
        create(:transaction, order: order)
        expect { delete :destroy, {id: order} }.to change{ Transaction.count }.by(-1)
      end

      it "destroys the associated addresses" do
        session[:cart_id] = cart.id
        create(:address, address_type: 'billing', addressable: order)
        create(:address, address_type: 'shipping', addressable: order)
        expect { delete :destroy, {id: order} }.to change{ Address.count }.by(-2)
      end

      it "does not destroy the associated product" do
        session[:cart_id] = cart.id
        product = create(:product)
        option = create(:option, product: product)
        create(:line_item, cart: cart, product: product, option: option)
        expect { delete :destroy, {id: order} }.not_to change{ Product.count }
      end

      it "does not destroy the associated option" do
        session[:cart_id] = cart.id
        product = create(:product)
        option = create(:option, product: product)
        create(:line_item, cart: cart, product: product, option: option)
        expect { delete :destroy, {id: order} }.not_to change{ Option.count }
      end

      it "redirects to the orders list" do
        session[:cart_id] = cart.id
        delete :destroy, {id: order}
        expect(response).to redirect_to(orders_path)
      end
    end

    describe "GET #delete_abandoned", :vcr do
      it "does not destroy a completed order" do
        cart = create(:cart)
        order = create(:order, cart: cart)
        create(:address, address_type: 'billing', addressable: order)
        create(:address, address_type: 'shipping', addressable: order)
        create(:transaction, order: order)
        expect { get :delete_abandoned }.not_to change{ Order.count }
      end

      it "destroys orders without email" do
        cart = create(:cart)
        order = create(:order, cart: cart)
        order.update(email: nil)
        create(:address, address_type: 'billing', addressable: order)
        create(:address, address_type: 'shipping', addressable: order)
        create(:transaction, order: order)
        expect { get :delete_abandoned }.to change{ Order.count }.by(-1)
      end

      it "destroys orders without billing address" do
        cart = create(:cart)
        order = create(:order, cart: cart)
        create(:address, address_type: 'shipping', addressable: order)
        create(:transaction, order: order)
        expect { get :delete_abandoned }.to change{ Order.count }.by(-1)
      end

      it "destroys orders without shipping address" do
        cart = create(:cart)
        order = create(:order, cart: cart)
        create(:address, address_type: 'billing', addressable: order)
        create(:transaction, order: order)
        expect { get :delete_abandoned }.to change{ Order.count }.by(-1)
      end

      it "destroys orders without cart" do
        order = create(:order, cart: nil)
        create(:address, address_type: 'billing', addressable: order)
        create(:address, address_type: 'shipping', addressable: order)
        create(:transaction, order: order)
        expect { get :delete_abandoned }.to change{ Order.count }.by(-1)
      end

      it "destroys orders without transaction" do
        cart = create(:cart)
        order = create(:order, cart: cart)
        create(:address, address_type: 'billing', addressable: order)
        create(:address, address_type: 'shipping', addressable: order)
        expect { get :delete_abandoned }.to change{ Order.count }.by(-1)
      end
    end
  end

  context 'guest and user access' do

    before { test_sign_out(false) }

    describe 'GET #new' do
      it "doesn't exist" do
        expect { get :new }.to raise_error(ActionController::UrlGenerationError)
      end
    end 

    describe "GET #edit" do
      it "doesn't exist", :vcr do
        order = build_stubbed(:order)
        expect { get :edit, id: order }.to raise_error(ActionController::UrlGenerationError)
      end
    end

    describe 'GET #index' do
      it "requires login" do
        get :index
        expect(response).to redirect_to home_path
      end
    end

    describe 'GET #show' do
      it "requires login", :vcr do
        order = create(:order)
        get :show, id: order
        expect(response).to redirect_to home_path
      end
    end

  #   describe "POST create" do
  #     describe "with valid params" do
  #       it "creates a new Order" do
  #         expect {
  #           post :create, {:order => valid_attributes}, valid_session
  #         }.to change(Order, :count).by(1)
  #       end

  #       it "assigns a newly created order as @order" do
  #         post :create, {:order => valid_attributes}, valid_session
  #         assigns(:order).should be_a(Order)
  #         assigns(:order).should be_persisted
  #       end

  #       it "redirects to the created order" do
  #         post :create, {:order => valid_attributes}, valid_session
  #         response.should redirect_to(Order.last)
  #       end
  #     end

  #     describe "with invalid params" do
  #       it "assigns a newly created but unsaved order as @order" do
  #         # Trigger the behavior that occurs when invalid params are submitted
  #         Order.any_instance.stub(:save).and_return(false)
  #         post :create, {:order => { "cart_id" => "invalid value" }}, valid_session
  #         assigns(:order).should be_a_new(Order)
  #       end

  #       it "re-renders the 'new' template" do
  #         # Trigger the behavior that occurs when invalid params are submitted
  #         Order.any_instance.stub(:save).and_return(false)
  #         post :create, {:order => { "cart_id" => "invalid value" }}, valid_session
  #         response.should render_template("new")
  #       end
  #     end
  #   end

    describe "POST #create" do
      context "empty cart" do
        it "redirects to products page" do
          cart = create(:cart)
          session[:cart_id] = cart.id
          post :create
          expect(response).to redirect_to products_path
        end
      end

      context "items in cart" do
        it "redirects to address page" do
          cart = create(:cart)
          product = create(:product)
          option = create(:option, product: product)
          create(:line_item, cart: cart, product: product, option: option)
          session[:cart_id] = cart.id
          post :create
          expect(response).to redirect_to addresses_order_path(Order.last.id)
        end
      end
    end

    describe "GET #addresses" do
      let(:address) { create(:address) }
      let(:order) { Order.new }
      it "renders address template" do
        order.save!
        get :addresses, address_id: address, id: order
        expect(response).to render_template(:addresses)
      end
    end

    describe "POST #create_addresses" do
      let(:address) { create(:address) }
      let(:valid_address) { attributes_for(:address) }
      let(:invalid_address) { attributes_for(:address, first_name: nil) }
      let(:order) { Order.new }
      context "valid addresses" do
        it "redirects to shipping path" do
          order.save!
          post :create_addresses, { id: order, order_id: order, order: { addresses_attributes: { "0" => valid_address, "1" => valid_address }}}
          expect(response).to redirect_to shipping_order_path(Order.last.id)
        end
      end
      context "invalid addresses" do
        it "renders address template" do
          order.save!
          post :create_addresses, { id: order, order_id: order, order: { addresses_attributes: { "0" => invalid_address, "1" => invalid_address }}}
          expect(response).to render_template(:addresses)
        end
      end
    end

    describe "GET #shipping", :vcr do
      context "order exists" do
        it "renders shipping form" do
          cart = create(:cart)
          product = create(:n72)
          option = create(:ka, product: product)
          create(:line_item, cart: cart, product: product, option: option)
          order = create(:paypal_order, cart: cart, state: 'order_addressed')
          create(:billing_constant_taxable, addressable: order)
          create(:shipping_constant_taxable, addressable: order)
          get :shipping, id: order.to_param
          expect(response).to render_template(:shipping)
        end
      end
      context "order does not exist" do
        it "raises error" do
          expect { get :shipping }.to raise_error
        end
      end
    end

    describe "POST #update_shipping" do
      let(:order) { Order.new }
      context "order exists" do
        it "redirects to confirm order path" do
          order.save!
          post :update_shipping, id: order, order: { shipping_method: "USPS Priority Mail 1-Day, 670" }
          expect(response).to redirect_to confirm_order_path(Order.last.id)
        end
      end
      context "order does not exist" do
        it "raises error" do
          expect { post :update_shipping }.to raise_error
        end
      end
    end

    describe "GET #confirm" do
      let(:order) { Order.new }
      context "order exists" do
        it "renders order confirmation page" do
          order.save!
          get :confirm, id: order, order: order
        end
      end
      context "order does not exist" do
        it "renders order confirmation page" do
          expect { get :confirm }.to raise_error
        end
      end
    end

    describe "PATCH #update_confirm" do
      context "order exists" do
        let(:order) { Order.new }
        it "redirects ahead with terms accepted" do
          order.save!
          patch :update_confirm, id: order, order: { express_token: "", accept_terms: "1" } 
          expect(response).to redirect_to payment_order_path Order.last.id
        end
        it "redirects back with terms not accepted" do
          order.save!
          patch :update_confirm, id: order, order: { express_token: "", accept_terms: "0" } 
          expect(response).to redirect_to confirm_order_path(order)
        end
      end
      context "order does not exist" do
        it "raises error" do
          expect { patch :update_confirm }.to raise_error
        end
      end
    end

    describe "GET #payment" do
      context "order exists" do
        let(:order) { Order.new }
        it "renders payment template" do
          order.save!
          get :payment, id: order, order: order
          expect(response).to render_template(:payment)
        end
      end
      context "order does not exist" do
        it "raises error" do
          expect { get :payment }.to raise_error
        end
      end
    end

    describe 'PATCH #update' do
      it "requires login" do
        expect { patch :update }.to raise_error
      end
    end

  #   describe "PUT update" do
  #     describe "with valid params" do
  #       it "updates the requested order" do
  #         order = Order.create! valid_attributes
  #         # Assuming there are no other orders in the database, this
  #         # specifies that the Order created on the previous line
  #         # receives the :update_attributes message with whatever params are
  #         # submitted in the request.
  #         Order.any_instance.should_receive(:update).with({ "cart_id" => "1" })
  #         put :update, {:id => order.to_param, :order => { "cart_id" => "1" }}, valid_session
  #       end

  #       it "assigns the requested order as @order" do
  #         order = Order.create! valid_attributes
  #         put :update, {:id => order.to_param, :order => valid_attributes}, valid_session
  #         assigns(:order).should eq(order)
  #       end

  #       it "redirects to the order" do
  #         order = Order.create! valid_attributes
  #         put :update, {:id => order.to_param, :order => valid_attributes}, valid_session
  #         response.should redirect_to(order)
  #       end
  #     end

  #     describe "with invalid params" do
  #       it "assigns the order as @order" do
  #         order = Order.create! valid_attributes
  #         # Trigger the behavior that occurs when invalid params are submitted
  #         Order.any_instance.stub(:save).and_return(false)
  #         put :update, {:id => order.to_param, :order => { "cart_id" => "invalid value" }}, valid_session
  #         assigns(:order).should eq(order)
  #       end

  #       it "re-renders the 'edit' template" do
  #         order = Order.create! valid_attributes
  #         # Trigger the behavior that occurs when invalid params are submitted
  #         Order.any_instance.stub(:save).and_return(false)
  #         put :update, {:id => order.to_param, :order => { "cart_id" => "invalid value" }}, valid_session
  #         response.should render_template("edit")
  #       end
  #     end
  #   end

    describe 'DELETE #destroy' do
      it "requires login" do
        expect { delete :destroy }.to raise_error
      end
    end
  end
end