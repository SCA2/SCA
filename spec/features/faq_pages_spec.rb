require 'spec_helper'

describe "FAQs" do

  subject { page }
  
  describe "faq page as user" do
    before { visit faqs_path }
    
    it { should have_title('FAQ') }
    it { should have_content('Ordering') }
    it { should have_content('General') }
    it { should have_content('Assembly') }
    it { should have_content('Support') }
    it { should_not have_button('New Faq') }
    it { should_not have_button('New Faq') }
    it { should_not have_button('New Faq') }

  end
  
  describe "faq page as admin" do
    let(:user) { FactoryGirl.create(:user) }
#    user.toggle!(:admin)

    before { sign_in user }
    before { visit faqs_path }
    
    it { should have_title('FAQ') }
    it { should have_content('Ordering') }
    it { should have_content('General') }
    it { should have_content('Assembly') }
    it { should have_content('Support') }
    it { should_not have_button('New Faq') }
    it { should_not have_button('New Faq') }
    it { should_not have_button('New Faq') }

  end
end
