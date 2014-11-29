require 'rails_helper'

describe FeaturesController do

  let!(:product) { create(:product) }
  let!(:feature) { create(:feature, product: product) }
  let(:valid_attributes) { build(:feature, product: product, model: "A12", caption: "Feature Caption", description: "Feature description", sort_order: 1).attributes }
  let(:invalid_attributes) { build(:feature, product: product, sort_order: nil).attributes }

  shared_examples('admin access to features') do
    describe "GET new" do
      it "assigns a new feature as @feature" do
        get :new, id: feature, product_id: product.id
        expect(assigns(:feature)).to be_a_new(Feature)
      end
    end
  
    describe "GET edit" do
      it "assigns the requested feature as @feature" do
        get :edit, id: feature, product_id: product.id
        expect(assigns(:feature)).to eq(feature)
      end
    end
  
    describe "POST create" do
      describe "with valid params" do
        it "creates a new Feature" do
          expect {
            post :create, { feature: valid_attributes, product_id: product.id }
          }.to change(Feature, :count).by(1)
        end
  
        it "assigns a newly created feature as @feature" do
          post :create, { feature: valid_attributes, product_id: product.id }
          expect(assigns(:feature)).to be_a(Feature)
          expect(assigns(:feature)).to be_persisted
        end
  
        it "redirects to the created feature" do
          post :create, { feature: valid_attributes, product_id: product.id }
          expect(response).to redirect_to(product)
        end
      end
  
      describe "with invalid params" do
        it "assigns a newly created but unsaved feature as @feature" do
          post :create, { feature: invalid_attributes, product_id: product.id }
          expect(assigns(:feature)).to be_a_new(Feature)
        end
  
        it "re-renders the 'new' template" do
          post :create, { feature: invalid_attributes, product_id: product.id }
          expect(response).to render_template("new")
        end
      end
    end
  
    describe "PATCH #update" do
      describe "with valid params" do
        it "assigns the requested feature as @feature" do
          patch :update, id: feature.to_param, feature: valid_attributes, product_id: product.id
          expect(assigns(:feature)).to eq(feature)
        end
  
        it "changes feature's attributes" do
          patch :update, id: feature, feature: { caption: 'New caption' }, product_id: product.id
          feature.reload
          expect(feature.caption).to eq('New caption')
        end

        it "redirects to the feature" do
          patch :update, id: feature.to_param, feature: valid_attributes, product_id: product.id
          expect(response).to redirect_to(product)
        end
      end
  
      describe "with invalid params" do
        it "does not change feature's attributes" do
          patch :update, id: feature, feature: { caption: nil }, product_id: product.id
          feature.reload
          expect(feature.caption).not_to eq('New caption')
        end

        it "re-renders the 'edit' template" do
          patch :update, id: feature.to_param, feature: invalid_attributes, product_id: product.id
          expect(response).to render_template("edit")
        end
      end
    end
  
    describe "DELETE destroy" do
      it "destroys the requested feature" do
        feature.save!
        expect {
          delete :destroy, id: feature, product_id: product.id
        }.to change(Feature, :count).by(-1)
      end
  
      it "redirects to the features list" do
        delete :destroy, id: feature, product_id: product.id
        expect(response).to redirect_to(product)
      end
    end
  end

  describe 'admin access to features' do
    let(:admin) { create(:admin) }
    before { test_sign_in(admin, false) }
    it_behaves_like 'admin access to features'
  end
end
