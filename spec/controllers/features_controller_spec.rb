require 'rails_helper'

describe FeaturesController do

  let(:product) { FactoryGirl.create(:product) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:feature) }

  shared_examples('restricted access to features') do
    describe "GET index" do
      it "assigns all features as @features" do
        feature = Feature.create! valid_attributes
        get :index, {}
        assigns(:features).should eq([feature])
      end
    end
  end

  shared_examples('unrestricted access to features') do
    describe "GET show" do
      it "assigns the requested feature as @feature" do
        feature = Feature.create! valid_attributes
        get :show, {:id => feature.to_param}
        assigns(:feature).should eq(feature)
      end
    end
  
    describe "GET new" do
      it "assigns a new feature as @feature" do
        get :new, {}
        assigns(:feature).should be_a_new(Feature)
      end
    end
  
    describe "GET edit" do
      it "assigns the requested feature as @feature" do
        feature = Feature.create! valid_attributes
        get :edit, {:id => feature.to_param}
        assigns(:feature).should eq(feature)
      end
    end
  
    describe "POST create" do
      describe "with valid params" do
        it "creates a new Feature" do
          expect {
            post :create, {:feature => valid_attributes}
          }.to change(Feature, :count).by(1)
        end
  
        it "assigns a newly created feature as @feature" do
          post :create, {:feature => valid_attributes}
          assigns(:feature).should be_a(Feature)
          assigns(:feature).should be_persisted
        end
  
        it "redirects to the created feature" do
          post :create, {:feature => valid_attributes}
          response.should redirect_to(Feature.last)
        end
      end
  
      describe "with invalid params" do
        it "assigns a newly created but unsaved feature as @feature" do
          # Trigger the behavior that occurs when invalid params are submitted
          Feature.any_instance.stub(:save).and_return(false)
          post :create, {:feature => {  }}
          assigns(:feature).should be_a_new(Feature)
        end
  
        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Feature.any_instance.stub(:save).and_return(false)
          post :create, {:feature => {  }}
          response.should render_template("new")
        end
      end
    end
  
    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested feature" do
          feature = Feature.create! valid_attributes
          # Assuming there are no other features in the database, this
          # specifies that the Feature created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Feature.any_instance.should_receive(:update).with({ "these" => "params" })
          put :update, {:id => feature.to_param, :feature => { "these" => "params" }}
        end
  
        it "assigns the requested feature as @feature" do
          feature = Feature.create! valid_attributes
          put :update, {:id => feature.to_param, :feature => valid_attributes}
          assigns(:feature).should eq(feature)
        end
  
        it "redirects to the feature" do
          feature = Feature.create! valid_attributes
          put :update, {:id => feature.to_param, :feature => valid_attributes}
          response.should redirect_to(feature)
        end
      end
  
      describe "with invalid params" do
        it "assigns the feature as @feature" do
          feature = Feature.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Feature.any_instance.stub(:save).and_return(false)
          put :update, {:id => feature.to_param, :feature => {  }}
          assigns(:feature).should eq(feature)
        end
  
        it "re-renders the 'edit' template" do
          feature = Feature.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Feature.any_instance.stub(:save).and_return(false)
          put :update, {:id => feature.to_param, :feature => {  }}
          response.should render_template("edit")
        end
      end
    end
  
    describe "DELETE destroy" do
      it "destroys the requested feature" do
        feature = Feature.create! valid_attributes
        expect {
          delete :destroy, {:id => feature.to_param}
        }.to change(Feature, :count).by(-1)
      end
  
      it "redirects to the features list" do
        feature = Feature.create! valid_attributes
        delete :destroy, {:id => feature.to_param}
        response.should redirect_to(features_url)
      end
    end
  end

  describe 'admin access to features' do
    before do
      admin = create(:admin)
      sign_in admin, no_capybara: true
    end
    it_behaves_like 'restricted access to features'
    it_behaves_like 'unrestricted access to features'
  end

  describe 'user access to features' do
    it_behaves_like 'restricted access to features'
  end
end
