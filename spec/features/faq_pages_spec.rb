require 'rails_helper'

describe "FAQ page" do

  before { visit faqs_path }
  subject { page }
  
  it { is_expected.to have_title('FAQ') }
  it { is_expected.not_to have_content("<div class='section_header'>Ordering</div>") }
  it { is_expected.not_to have_content("<div class='section_header'>General</div>") }
  it { is_expected.not_to have_content("<div class='section_header'>Assembly</div>") }
  it { is_expected.not_to have_content("<div class='section_header'>Support</div>") }

  context "faq page as user" do
    let(:user) { create(:user) }

    before { test_sign_in user }
    before { visit faqs_path }

    it { is_expected.to have_title('FAQ') }
    it { is_expected.not_to have_content('New Faq') }
  end
  
  context "faq page as admin" do
    let(:admin) { create(:admin) }

    before { test_sign_in admin }
    before { visit faqs_path }

    it { is_expected.to have_title('FAQ') }
    it { is_expected.to have_content('New Faq') }
  end
end
