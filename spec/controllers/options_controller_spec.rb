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
        get :new, product_id: product
        expect(response).to render_template("new")
      end
    end
  
    describe "GET #edit" do
      it "assigns the requested option as @option" do
        get :edit, id: option, product_id: product
        expect(assigns(:option)).to eq(option)
      end
    end
  
    describe "POST #create" do
      describe "with valid params" do
        it "creates a new Option" do
          expect {
            post :create, option_editor: valid_attributes[:option_editor], product_id: product
          }.to change(Option, :count).by(1)
        end
  
        it "redirects to new bom path" do
          post :create, option_editor: valid_attributes[:option_editor], product_id: product
          expect(response).to redirect_to(edit_bom_path(Bom.last.id))
        end
      end
  
      describe "with invalid params" do
        it "re-renders the 'new' template" do
          post :create, invalid_attributes
          expect(response).to render_template("new")
        end
      end
    end
  
    describe "PATCH #update" do
      describe "with valid params" do
        it "redirects to the option" do
          patch :update, valid_attributes
          expect(response).to redirect_to(product)
        end
      end
  
      describe "with invalid params" do
        it "re-renders the 'edit' template" do
          patch :update, invalid_attributes
          expect(response).to render_template("edit")
        end
      end
    end
  
    describe "DELETE #destroy" do
      it "destroys the requested option" do
        option.save!
        expect {
          delete :destroy, id: option, product_id: product
        }.to change(Option, :count).by(-1)
      end
  
      it "redirects to the options list" do
        delete :destroy, id: option, product_id: product
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
