require 'spec_helper'

describe FaqsController do

  shared_examples('public access to faqs') do
    describe 'GET #index' do
      let(:faq) { create(:faq, group: 'General', priority: 1) }
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
  
  shared_examples('full access to faqs') do
    describe 'GET #show' do   
      let(:faq) { create(:faq) }
      
      it "assigns the requested faq to @faq" do
        get :show, id: faq
        expect(assigns(:faq)).to eq faq
      end
      
      it "renders the :show template" do
        get :show, id: faq 
        expect(response).to render_template :show 
      end
    end
    
    describe 'GET #new' do
      let(:user) { create(:user, :admin => true) }
      before { sign_in user, no_capybara: true }
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
      before { sign_in user, no_capybara: true }
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
      let(:user) { create(:user, :admin => true) }
      before { @faq = attributes_for(:faq) }
      before { sign_in user, no_capybara: true }
      context "with valid attributes" do
        it "saves the new faq in the database" do
          expect {post :create, faq: 
            attributes_for(:faq)}.to change(Faq, :count).by(1)
        end
        it "redirects to faqs#show" do
          post :create, faq: attributes_for(:faq)
          expect(response).to redirect_to faq_path(assigns[:faq])
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
      before { @faq = create(:faq, question: 'Why?', answer: 'Because I said so') }
      let(:user) { create(:user, :admin => true) }
      before { sign_in user, no_capybara: true }
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
        it "redirects to the faq" do
          patch :update, id: @faq, faq: attributes_for(:faq)
          expect(response).to redirect_to @faq
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
      before { sign_in user, no_capybara: true }
      it "deletes the faq from the database" do
        expect { delete :destroy, id: @faq }.to change(Faq, :count).by(-1)
      end
      it "redirects to users#index" do
        delete :destroy, id: @faq
        expect(response).to redirect_to faqs_url
      end
    end
  end
  
  shared_examples('requires login') do
    describe 'GET #show' do   
      let(:faq) { create(:faq) }
      it 'redirects to faqs#index' do
        get :show, id: faq 
        expect(response).to redirect_to :action => :index
      end
    end
    
    describe 'GET #new' do
      it "redirects to faqs#index" do
        get :new 
        expect(response).to redirect_to :action => :index
      end
    end
    
    describe 'GET #edit' do
      let(:faq) { create(:faq) }
      it 'redirects to faqs#index' do
        get :edit, id: faq
        expect(response).to redirect_to :action => :index        
      end
    end
    
    describe "POST #create" do
      before { @faq = attributes_for(:faq) }
      it 'redirects to faqs#index' do
        post :create, faq: attributes_for(:faq)
        expect(response).to redirect_to :action => :index        
      end
    end
    
    describe 'PATCH #update' do
      before { @faq = create(:faq) }
      it 'redirects to faqs#index' do
        patch :update, id: @faq, faq: attributes_for(:faq)
        expect(response).to redirect_to :action => :index        
      end
    end
    
    describe 'DELETE #destroy' do
      before { @faq = create(:faq) }
      it 'redirects to faqs#index' do
        delete :destroy, id: @faq
        expect(response).to redirect_to :action => :index        
      end
    end
  end

  describe 'admin access to faqs' do
    before do
      admin = create(:admin)
      sign_in admin, no_capybara: true
    end
    it_behaves_like 'public access to faqs'
    it_behaves_like 'full access to faqs'
  end

  describe 'user access to faqs' do
    before do
      user = create(:user)
      sign_in user, no_capybara: true
    end
    it_behaves_like 'public access to faqs'
    it_behaves_like 'requires login'
  end

  describe 'admin access to faqs' do
    it_behaves_like 'public access to faqs'
    it_behaves_like 'requires login'
  end
end


