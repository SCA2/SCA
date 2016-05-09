require 'rails_helper'

describe OrdersController do

  shared_examples 'public access' do
    describe 'GET #index' do
      it "requires login" do
        get :index
        expect(response).to redirect_to home_path
      end
    end
    describe 'GET #show' do
      it "requires login" do
        expect { get :show }.to raise_error
      end
    end
    describe 'GET #new' do
      it "requires login" do
        expect { get :new }.to raise_error
      end
    end
    
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

    describe "GET #shipping" do
      let(:order) { Order.new }
      context "order exists" do
        it "renders shipping form" do
          order.save!
          get :shipping, id: order
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

    describe 'DELETE #destroy' do
      it "requires login" do
        expect { delete :destroy }.to raise_error
      end
    end
  end

  shared_examples 'limited access' do
    context 'user not signed in' do
      describe 'GET #show' do
        it "requires login" do
          get :show, id: user
          expect(response).to redirect_to signin_path
        end
      end
      describe "POST #create" do
        it "requires login" do
          post :create, id: user, user: valid_attributes
          expect(response).to redirect_to User.last
        end
      end
      describe 'PATCH #update' do
        it "requires login" do
          patch :update, id: user, user: valid_attributes
          expect(response).to redirect_to signin_path
        end
      end
    end

    context 'user signed in' do
      before { test_sign_in(user, false) }
      describe 'GET #show' do
        it "requires login" do
          get :show, id: user
          expect(response).to render_template(:show)
        end
      end
      describe 'GET #show admin' do
        it "requires login" do
          get :show, id: admin
          expect(response).to redirect_to home_path
        end
      end
      describe "POST #create" do
        it "requires login" do
          post :create, id: user, user: valid_attributes
          expect(response).to redirect_to home_path
          expect(flash[:notice]).to include("Already signed up!")
        end
      end
      describe 'PATCH #update' do
        it "requires login" do
          patch :update, id: user, user: valid_attributes
          expect(response).to redirect_to user
        end
      end
    end

    context 'either' do
      describe 'DELETE #destroy' do
        it "requires login" do
          delete :destroy, id: user
          expect(response).to redirect_to home_path
        end
      end
    end
  end

  shared_examples 'full access' do
    context 'admin signed in' do
      before { test_sign_in(admin, false) }
      describe 'GET #index' do
        it "requires login" do
          get :index
          expect(response).to render_template(:index)
        end
      end
      describe 'DELETE #destroy' do
        it "requires login" do
          delete :destroy, id: user
          expect(response).to redirect_to users_path
          expect(flash[:success]).to include("User deleted")
        end
      end
    end
  end

  #   describe "GET index" do
  #     it "assigns all orders as @orders" do
  #       order = Order.create! valid_attributes
  #       get :index, {}, valid_session
  #       assigns(:orders).should eq([order])
  #     end
  #   end

  #   describe "GET show" do
  #     it "assigns the requested order as @order" do
  #       order = Order.create! valid_attributes
  #       get :show, {:id => order.to_param}, valid_session
  #       assigns(:order).should eq(order)
  #     end
  #   end

  #   describe "GET new" do
  #     it "assigns a new order as @order" do
  #       get :new, {}, valid_session
  #       assigns(:order).should be_a_new(Order)
  #     end
  #   end

  #   describe "GET edit" do
  #     it "assigns the requested order as @order" do
  #       order = Order.create! valid_attributes
  #       get :edit, {:id => order.to_param}, valid_session
  #       assigns(:order).should eq(order)
  #     end
  #   end

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

  #   describe "DELETE destroy" do
  #     it "destroys the requested order" do
  #       order = Order.create! valid_attributes
  #       expect {
  #         delete :destroy, {:id => order.to_param}, valid_session
  #       }.to change(Order, :count).by(-1)
  #     end

  #     it "redirects to the orders list" do
  #       order = Order.create! valid_attributes
  #       delete :destroy, {:id => order.to_param}, valid_session
  #       response.should redirect_to(orders_url)
  #     end
  #   end
  # end

  # describe "user access to orders" do
  #   let(:user) { create(:user) }
  #   it_behaves_like "public access"
  #   it_behaves_like "limited access"
  # end

  describe "guest access to orders" do
    let(:valid_address) { attributes_for(:address) }
    it_behaves_like "public access"
  end
end
