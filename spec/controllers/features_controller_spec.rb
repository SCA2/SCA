require 'rails_helper'

describe FeaturesController do

  let!(:product) { create(:product) }
  let!(:feature) { create(:feature, product: product) }
  let(:valid_attributes) { attributes_for(:feature, product: product, caption: "Caption", description: "Description", sort_order: 1) }
  let(:invalid_attributes) { attributes_for(:feature, product: product, sort_order: nil) }

  shared_examples('admin access to features') do
    describe "GET new" do
      it "assigns a new feature as @feature" do
        get :new, params: { id: feature, product_id: product.to_param }
        expect(response).to be_successful
      end
    end
  
    describe "GET edit" do
      it "assigns the requested feature as @feature" do
        get :edit, params: { id: feature, product_id: product.to_param }
        expect(response).to be_successful
      end
    end
  
    describe "POST create" do
      describe "with valid params" do
        it "creates a new Feature" do
          expect {
            post :create, params: { feature: valid_attributes, product_id: product.to_param }
          }.to change(Feature, :count).by(1)
        end
  
        it "redirects to new feature path" do
          post :create, params: { feature: valid_attributes, product_id: product.to_param }
          expect(response).to redirect_to(new_product_feature_path(product.to_param))
        end
      end
  
      describe "with invalid params" do
        it "assigns a newly created but unsaved feature as @feature" do
          post :create, params: { feature: invalid_attributes, product_id: product.to_param }
          expect(response).to be_successful
        end
      end
    end
  
    describe "PATCH #update" do
      describe "with valid params" do
        it "changes feature's attributes" do
          patch :update, params: {
            id: feature,
            feature: { caption: 'New caption' },
            product_id: product.to_param
          }
          feature.reload
          expect(feature.caption).to eq('New caption')
        end

        it "redirects to the feature" do
          patch :update, params: {
            id: feature.to_param,
            feature: valid_attributes,
            product_id: product.to_param
          }
          expect(response).to redirect_to(product)
        end
      end
  
      describe "with invalid params" do
        it "does not change feature's attributes" do
          patch :update, params: { id: feature, feature: { caption: nil }, product_id: product.to_param }
          feature.reload
          expect(feature.caption).not_to eq('New caption')
        end

        it "re-renders the 'edit' template" do
          patch :update, params: { id: feature.to_param, feature: invalid_attributes, product_id: product. to_param }
          expect(response).to be_successful
        end
      end
    end
  
    describe "DELETE destroy" do
      it "destroys the requested feature" do
        feature.save!
        expect {
          delete :destroy, params: { id: feature, product_id: product.to_param }
        }.to change(Feature, :count).by(-1)
      end
  
      it "redirects to the features list" do
        delete :destroy, params: { id: feature, product_id: product.to_param }
        expect(response).to redirect_to(product)
      end
    end
  end

  describe 'admin access to features' do
    let(:admin) { create(:admin) }
    before { test_sign_in(admin, use_capybara: false) }
    it_behaves_like 'admin access to features'
  end
end
