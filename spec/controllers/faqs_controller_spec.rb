require 'rails_helper'

describe FaqsController do

  include Capybara::DSL

  shared_examples('public access to faqs') do
    describe 'GET #index' do
      let(:faqs_category) { create(:faqs_category) }
      let(:faq) { create(:faq, faqs_category: faqs_category) }
      it "populates a sorted array of faqs" do
        get :index
        expect(assigns(:faq)).to eq(@faqs)
      end
      it "renders the :index template" do
        get :index
        expect(response).to render_template :index
      end
    end
  end
  
  shared_examples('admin access to faqs') do

    describe 'GET #new' do

      let(:user) { create(:user, :admin => true) }
      before { test_sign_in(user, false) }

      it "assigns a new Faq to @faq" do
        get :new
        expect(assigns(:faq)).to be_a_new(Faq)
      end
      it "renders the :new template" do
        get :new
        expect(response).to render_template :new
      end
    end
    
    describe 'GET #edit' do

      let(:user) { create(:user, :admin => true) }
      let(:faq) { create(:faq) }
      before { test_sign_in(user, false) }

      it "assigns the requested faq to @faq" do
        get :edit, id: faq
        expect(assigns(:faq)).to eq faq
      end
      it "renders the :edit template" do
        get :edit, id: faq
        expect(response).to render_template :edit        
      end
    end
    
    describe "POST #create" do
      let(:faqs_category) { create(:faqs_category) }
      let(:user) { create(:user, admin: true) }
      before { test_sign_in(user, false) }
      context "with valid attributes" do
        it "saves the new faq in the database" do
          expect {post :create, faq: 
            attributes_for(:faq, faqs_category_id: faqs_category.id)}.to change(Faq, :count).by(1)
        end
        it "renders :new template" do
          post :create, faq: attributes_for(:faq)
          expect(response).to render_template :new
        end
      end
      context "with invalid attributes" do
        it "does not save the new faq in the database" do
          expect {post :create, faq: 
            attributes_for(:invalid_faq)}.not_to change(Faq, :count)          
        end
        it "re-renders the :new template" do
          post :create, faq: attributes_for(:invalid_faq)
          expect(response).to render_template :new
        end
      end
    end
    
    describe 'PATCH #update' do
      before { @faq = create(:faq, question: 'Why?', answer: 'Because I said') }
      let(:user) { create(:user, :admin => true) }
      before { test_sign_in(user, false) }
      context "with valid attributes" do
        it "locates the requested @faq" do
          patch :update, id: @faq, faq: attributes_for(:faq)
          expect(assigns(:faq)).to eq(@faq)
        end
        it "changes @faq's attributes" do
          patch :update, id: @faq, faq: attributes_for(:faq, question: 'Why?', answer: 'Because')
          @faq.reload
          expect(@faq.question).to eq('Why?')
          expect(@faq.answer).to eq('Because')
        end
        it "redirects to the index" do
          patch :update, id: @faq, faq: attributes_for(:faq)
          expect(response).to redirect_to faqs_path
        end
      end
      context "with invalid attributes" do
        it "does not change @faq's attributes" do
          patch :update, id: @faq, faq: attributes_for(:faq, question_weight: 0, answer: 'Because')
          @faq.reload
          expect(@faq.question).to eq('Why?')
          expect(@faq.answer).not_to eq('Because')
        end
        it "re-renders the #edit template" do
          patch :update, id: @faq, faq: attributes_for(:invalid_faq)
          expect(response).to render_template :edit
        end
      end
    end
    
    describe 'DELETE #destroy' do
      before { @faq = create(:faq) }
      let(:user) { create(:user, :admin => true) }
      before { test_sign_in(user, false) }
      it "deletes the faq from the database" do
        expect { delete :destroy, id: @faq }.to change(Faq, :count).by(-1)
      end
      it "redirects to faqs#index" do
        delete :destroy, id: @faq
        expect(response).to redirect_to faqs_path
      end
    end
  end
  
  describe 'admin access to faqs' do

    let(:admin) { create(:admin) }
    before { test_sign_in(admin, false) }
    it_behaves_like 'public access to faqs'
    it_behaves_like 'admin access to faqs'
  end

  describe 'public access to faqs' do
    before do
      user = create(:user)
      test_sign_in(user, false)
    end
    it_behaves_like 'public access to faqs'
  end

end



