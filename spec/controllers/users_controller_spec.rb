require 'rails_helper'

describe UsersController do

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
        get :new
        expect(response).to render_template(:new)
      end
    end
    describe "POST #create" do
      it "requires login" do
        expect { post :create }.to raise_error
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
    it_behaves_like "public access"
  end
end
