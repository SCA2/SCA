require 'rails_helper'

describe OptionsController do

  let(:product) { create(:product) }
  let!(:option) { create(:option, product: product) }
  let!(:bom) { create(:bom, option: option) }
  let!(:bom_item) { create(:bom_item, bom: bom) }

  let(:valid_attributes) { attributes_for(:option_editor, product: product, option: option) }
  let(:invalid_attributes) { attributes_for(:bad_editor, product: product, option: option) }

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
            post :create, params: { option_editor: valid_attributes[:option_editor], product_id: product }
          }.to change(Option, :count).by(1)
        end
  
        it "redirects to new bom path" do
          post :create, params: { option_editor: valid_attributes[:option_editor], product_id: product }
          expect(response).to redirect_to(edit_bom_path(Bom.last.id))
        end
      end
  
      describe "with invalid params" do
        it "re-renders the 'new' template" do
          post :create, params: invalid_attributes
          expect(response).to be_successful
        end
      end
    end
  
    describe "PATCH #update" do
      describe "with valid params" do
        it "redirects to the option" do
          patch :update, params: valid_attributes
          expect(response).to redirect_to(product)
        end
      end
  
      describe "with invalid params" do
        it "re-renders the 'edit' template" do
          patch :update, params: invalid_attributes
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
