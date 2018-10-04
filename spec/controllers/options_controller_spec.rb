require 'rails_helper'

describe OptionsController do

  let(:tag)       { create(:size_weight_price_tag) }
  let(:component) { create(:component, size_weight_price_tag: tag) }
  let(:product)   { create(:product) }
  let(:option)    { create(:option, product: product, component: component) }

  let(:valid_option)    { attributes_for(:option, sort_order: 10, active: true) }
  let(:invalid_option)  { attributes_for(:option, sort_order: 10, active: nil) }

  shared_examples('admin access to options') do
    describe "GET #new" do
      it "renders the 'new' template" do
        create(:component, size_weight_price_tag: tag)
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
  end

  describe 'admin access to options' do
    let(:admin) { create(:admin) }
    before { test_sign_in(admin, use_capybara: false) }
    it_behaves_like 'admin access to options'
  end
end
