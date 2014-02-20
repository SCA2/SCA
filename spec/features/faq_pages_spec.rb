require 'spec_helper'

describe "FAQ page" do

  before { visit faqs_path }
  subject { page }
  
  it { should have_title('FAQ') }
  it { should_not have_content("<div class='section_header'>Ordering</div>") }
  it { should_not have_content("<div class='section_header'>General</div>") }
  it { should_not have_content("<div class='section_header'>Assembly</div>") }
  it { should_not have_content("<div class='section_header'>Support</div>") }

  context "faq page as user" do
    let(:user) { FactoryGirl.create(:user) }

    before { sign_in user }
    before { visit faqs_path }

    it { should have_title('FAQ') }
    it { should_not have_content('New Faq') }
    it { should_not have_content('Upload CSV') }
    it { should_not have_content('Download CSV') }
  end
  
  context "faq page as admin" do
    let(:admin) { FactoryGirl.create(:admin) }

    before { sign_in admin }
    before { visit faqs_path }

    it { should have_title('FAQ') }
    it { should have_content('New Faq') }
    it { should have_button('Upload CSV') }
    it { should have_content('Download CSV') }
  end
end
