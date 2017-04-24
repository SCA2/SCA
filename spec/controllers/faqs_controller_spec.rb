require 'rails_helper'

describe FaqsController do

  shared_examples('public access to faqs') do
    describe 'GET #index' do
      let(:faqs_category) { create(:faqs_category) }
      let(:faq) { create(:faq, faqs_category: faqs_category) }
      it "is successful" do
        get :index
        expect(response).to be_successful
      end
    end
  end
  
  shared_examples('admin access to faqs') do

    describe 'GET #new' do

      let(:user) { create(:user, admin: true) }
      before { test_sign_in(user, use_capybara: false) }
      it "is successful" do
        get :new
        expect(response).to be_successful
      end
    end
    
    describe 'GET #edit' do

      let(:user) { create(:user, admin: true) }
      let(:fq) { create(:faq) }
      before { test_sign_in(user, use_capybara: false) }
      it "is successful" do
        get :edit, params: { id: fq }
        expect(response).to be_successful
      end
    end
    
    describe "POST #create" do
      let(:faqs_category) { create(:faqs_category) }
      let(:user) { create(:user, admin: true) }
      before { test_sign_in(user, use_capybara: false) }
      context "with valid attributes" do
        it "is successful" do
          post :create, params: { faq: attributes_for(:faq) }
          expect(response).to be_successful
        end
        it "saves the new faq in the database" do
          expect { post :create, params: { faq: attributes_for(:faq, faqs_category_id: faqs_category.id) }}.to change(Faq, :count).by(1)
        end
      end
      context "with invalid attributes" do
        it "is successful" do
          post :create, params: { faq: attributes_for(:invalid_faq) }
          expect(response).to be_successful
        end
        it "does not save the new faq in the database" do
          expect { post :create, params: { faq: 
            attributes_for(:invalid_faq) }}.not_to change(Faq, :count)          
        end
      end
    end
    
    describe 'PATCH #update' do
      before { @faq = create(:faq, question: 'Why?', answer: 'Because I said') }
      let(:user) { create(:user, admin: true) }
      before { test_sign_in(user, use_capybara: false) }
      context "with valid attributes" do
        it "changes @faq's attributes" do
          patch :update, params: {
            id: @faq,
            faq: attributes_for(:faq, question: 'Why?', answer: 'Because')
          }
          @faq.reload
          expect(@faq.question).to eq('Why?')
          expect(@faq.answer).to eq('Because')
        end
        it "redirects to the index" do
          patch :update, params: { id: @faq, faq: attributes_for(:faq) }
          expect(response).to redirect_to faqs_path
        end
      end
      context "with invalid attributes" do
        it "does not change @faq's attributes" do
          patch :update, params: {
            id: @faq,
            faq: attributes_for(:faq, question_weight: 0, answer: 'Because')
          }
          @faq.reload
          expect(@faq.question).to eq('Why?')
          expect(@faq.answer).not_to eq('Because')
        end
        it "is successful" do
          patch :update, params: { id: @faq, faq: attributes_for(:invalid_faq) }
          expect(response).to be_successful
        end
      end
    end
    
    describe 'DELETE #destroy' do
      before { @faq = create(:faq) }
      let(:user) { create(:user, admin: true) }
      before { test_sign_in(user, use_capybara: false) }
      it "deletes the faq from the database" do
        expect { delete :destroy, params: { id: @faq }}.to change(Faq, :count).by(-1)
      end
      it "redirects to faqs#index" do
        delete :destroy, params: { id: @faq }
        expect(response).to redirect_to faqs_path
      end
    end
  end
  
  describe 'admin access to faqs' do

    let(:admin) { create(:admin) }
    before { test_sign_in(admin, use_capybara: false) }
    it_behaves_like 'public access to faqs'
    it_behaves_like 'admin access to faqs'
  end

  describe 'public access to faqs' do
    before do
      user = create(:user)
      test_sign_in(user, use_capybara: false)
    end
    it_behaves_like 'public access to faqs'
  end

end



