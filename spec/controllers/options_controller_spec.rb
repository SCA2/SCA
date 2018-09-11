require 'rails_helper'

describe OptionsController do

  let(:product)   { create(:product) }
  let(:component) { create(:component) }
  let(:option)    { create(:option, product: product, component: component) }

  let(:valid_option)    { attributes_for(:option, sort_order: 10, active: true) }
  let(:invalid_option)  { attributes_for(:option, sort_order: 10, active: nil) }

  shared_examples('admin access to options') do
    describe "GET #new" do
      it "renders the 'new' template" do
        get :new, params: { product_id: product }
        expect(response).to be_successful
      end
    end
  
    describe "GET #edit" do
      it "assigns the requested option as @option" do
        get :edit, params: { id: option, product_id: product }
        expect(response).to be_successful
      end
    end
  
    describe "POST #create" do
      describe "with valid params" do
        it "creates a new Option" do
          expect {
            post :create, params: {
              product_id: product,
              option: valid_option.merge(component_id: component.id)
            }
          }.to change(Option, :count).by(1)
        end
  
        it "redirects to new bom path" do
          post :create, params: {
            product_id: product,
            option: valid_option.merge(component_id: component.id)
          }
          expect(response).to redirect_to product
        end
      end
  
      describe "with invalid params" do
        it "re-renders the 'new' template" do
          post :create, params: {
            product_id: product,
            option: invalid_option.merge(component_id: component.id)
          }
          expect(response).to be_successful
        end
      end
    end
  
    describe "PATCH #update" do
      describe "with valid params" do
        it "redirects to the option" do
          patch :update, params: { id: option, product_id: product, option: valid_option }
          expect(response).to redirect_to(product)
        end
      end
  
      describe "with invalid params" do
        it "re-renders the 'edit' template" do
          patch :update, params: { id: option, product_id: product, option: invalid_option }
          expect(response).to be_successful
        end
      end
    end
  
    describe "DELETE #destroy" do
      it "destroys the requested option" do
        option.save!
        expect {
          delete :destroy, params: { id: option, product_id: product }
        }.to change(Option, :count).by(-1)
      end
  
      it "redirects to the options list" do
        delete :destroy, params: { id: option, product_id: product }
        expect(response).to redirect_to(product)
      end

      it "alerts if referenced by a cart" do
        cart = create(:cart)
        create(:line_item, cart: cart, option: option)
        delete :destroy, params: { product_id: product, id: option }
        expect(flash[:alert]).to include("Option #{option.model} is referenced by cart #{cart.id}")
      end
    end
  end

  describe 'admin access to options' do
    let(:admin) { create(:admin) }
    before { test_sign_in(admin, use_capybara: false) }
    it_behaves_like 'admin access to options'
  end
end
