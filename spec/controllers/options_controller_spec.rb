require 'rails_helper'

describe OptionsController do

  let!(:product) { create(:product) }
  let!(:option) { create(:option, product: product) }
  let(:valid_attributes) { attributes_for(:option, product: product, model: "KA-2H", description: "Option description", sort_order: 1) }
  let(:invalid_attributes) { attributes_for(:option, product: product, sort_order: nil) }

  shared_examples('admin access to options') do
    describe "GET #new" do
      it "assigns a new option as @option" do
        get :new, id: option, product_id: product.id
        expect(assigns(:option)).to be_a_new(Option)
      end
    end
  
    describe "GET #edit" do
      it "assigns the requested option as @option" do
        get :edit, id: option, product_id: product.id
        expect(assigns(:option)).to eq(option)
      end
    end
  
    describe "POST #create" do
      describe "with valid params" do
        it "creates a new Option" do
          expect {
            post :create, { option: valid_attributes, product_id: product.id }
          }.to change(Option, :count).by(1)
        end
  
        it "assigns a newly created option as @option" do
          post :create, { option: valid_attributes, product_id: product.id }
          expect(assigns(:option)).to be_a(Option)
          expect(assigns(:option)).to be_persisted
        end
  
        it "redirects to new option path" do
          post :create, { option: valid_attributes, product_id: product.id }
          expect(response).to redirect_to(new_product_option_path(product.id))
        end
      end
  
      describe "with invalid params" do
        it "assigns a newly created but unsaved option as @option" do
          post :create, { option: invalid_attributes, product_id: product.id }
          expect(assigns(:option)).to be_a_new(Option)
        end
  
        it "re-renders the 'new' template" do
          post :create, { option: invalid_attributes, product_id: product.id }
          expect(response).to render_template("new")
        end
      end
    end
  
    describe "PATCH #update" do
      describe "with valid params" do
        it "assigns the requested option as @option" do
          patch :update, id: option.to_param, option: valid_attributes, product_id: product.id
          expect(assigns(:option)).to eq(option)
        end
  
        it "changes option's attributes" do
          patch :update, id: option, option: { description: 'New description' }, product_id: product.id
          option.reload
          expect(option.description).to eq('New description')
        end

        it "redirects to the option" do
          patch :update, id: option.to_param, option: valid_attributes, product_id: product.id
          expect(response).to redirect_to(product)
        end
      end
  
      describe "with invalid params" do
        it "does not change option's attributes" do
          patch :update, id: option, option: { description: nil }, product_id: product.id
          option.reload
          expect(option.description).not_to eq('New description')
        end

        it "re-renders the 'edit' template" do
          patch :update, id: option.to_param, option: invalid_attributes, product_id: product.id
          expect(response).to render_template("edit")
        end
      end
    end
  
    describe "DELETE #destroy" do
      it "destroys the requested option" do
        option.save!
        expect {
          delete :destroy, id: option, product_id: product.id
        }.to change(Option, :count).by(-1)
      end
  
      it "redirects to the options list" do
        delete :destroy, id: option, product_id: product.id
        expect(response).to redirect_to(product)
      end
    end
  end

  describe 'admin access to options' do
    let(:admin) { create(:admin) }
    before { test_sign_in(admin, false) }
    it_behaves_like 'admin access to options'
  end
end
