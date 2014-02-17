require 'spec_helper'

describe "FAQ page" do

  before { visit faqs_path }
  subject { page }
  
  it { should have_title('FAQ') }
  it { should have_content('Ordering') }
  it { should have_content('General') }
  it { should have_content('Assembly') }
  it { should have_content('Support') }

  context "faq page as user" do
    let(:user) { FactoryGirl.create(:user, :admin => false) }

    before { sign_in user }
    before { visit faqs_path }

    it { should have_title('FAQ') }
    it { should_not have_content('New Faq') }
    it { should_not have_content('Upload Faqs') }
    it { should_not have_content('Download Faqs') }
  end
  
  context "faq page as admin" do
    let(:user) { FactoryGirl.create(:user, :admin => true) }

    before { sign_in user }
    before { visit faqs_path }
    
    it { should have_title('FAQ') }
    it { should have_content('New Faq') }
    it { should have_content('Upload Faqs') }
    it { should have_content('Download Faqs') }
  end
end
