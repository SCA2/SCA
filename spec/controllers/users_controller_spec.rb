require 'rails_helper'

describe UsersController do

  shared_examples 'public access' do
    describe 'GET #index' do
      it "requires admin" do
        get :index
        expect(response).to redirect_to home_path
      end
    end
    describe 'GET #show' do
      it "requires login" do
        get :show, params: { id: 0 }
        expect(response).to redirect_to signin_path
      end
    end
    describe 'GET #new' do
      it "renders form" do
        get :new
        expect(response).to be_successful
      end
    end
    describe "POST #create" do
      it "creates a user" do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to User.last
      end
    end
    describe 'PUT #update' do
      it "requires login" do
        put :update, params: { id: 0 }
        expect(response).to redirect_to signin_path
      end
    end
    describe 'DELETE #destroy' do
      it "requires admin" do
        delete :destroy, params: { id: 0 }
        expect(response).to redirect_to home_path
      end
    end
  end

  shared_examples 'limited access' do
    context 'user not signed in' do
      describe 'GET #show' do
        it "requires login" do
          get :show, params: { id: user }
          expect(response).to redirect_to signin_path
        end
      end
      describe 'PATCH #update' do
        it "requires login" do
          patch :update, params: { id: user, user: valid_attributes }
          expect(response).to redirect_to signin_path
        end
      end
    end

    context 'user signed in' do
      before { test_sign_in(user, use_capybara: false) }
      describe 'GET #show' do
        it "requires login" do
          get :show, params: { id: user }
          expect(response).to be_successful
        end
      end
      describe 'GET #show admin' do
        it "requires login" do
          get :show, params: { id: admin }
          expect(response).to redirect_to home_path
        end
      end
      describe "POST #create" do
        it "requires login" do
          post :create, params: { id: user, user: valid_attributes }
          expect(response).to redirect_to home_path
          expect(flash[:notice]).to include("Already signed up!")
        end
      end
      describe 'PATCH #update' do
        it "requires login" do
          patch :update, params: { id: user, user: valid_attributes }
          expect(response).to redirect_to user
        end
      end
    end

    context 'either' do
      describe 'DELETE #destroy' do
        it "requires login" do
          delete :destroy, params: { id: user }
          expect(response).to redirect_to home_path
        end
      end
    end
  end

  shared_examples 'full access' do
    context 'admin signed in' do
      before { test_sign_in(admin, use_capybara: false) }
      describe 'GET #index' do
        it "requires login" do
          get :index
          expect(response).to be_successful
        end
      end
      describe 'DELETE #destroy' do
        it "requires login" do
          delete :destroy, params: { id: user }
          expect(response).to redirect_to users_path
          expect(flash[:success]).to include("User deleted")
        end
      end
    end
  end

  describe "admin access to users" do
    let(:admin) { create(:admin) }
    let(:user) { create(:user) }
    let(:valid_attributes) { attributes_for(:user) }
    it_behaves_like "public access"
    it_behaves_like "limited access"
    it_behaves_like "full access"
  end

  describe "user access to users" do
    let(:admin) { create(:admin) }
    let(:user) { create(:user) }
    let(:valid_attributes) { attributes_for(:user) }
    it_behaves_like "public access"
    it_behaves_like "limited access"
  end

  describe "guest access to users" do
    let(:valid_attributes) { attributes_for(:user) }
    it_behaves_like "public access"
  end
end
