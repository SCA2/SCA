require 'spec_helper'

describe "home page" do

  before { visit home_path }
  subject { page }
  
  it { should have_title('Home') }

  context "home page as guest" do
    before { visit home_path }

    it { should have_title('Home') }
  end

  context "home page as user" do
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }
    before { visit home_path }

    it { should have_title('Home') }
  end
  
  context "home page as admin" do
    let(:admin) { FactoryGirl.create(:admin) }
    before { sign_in admin }
    before { visit home_path }
    
    it { should have_title('Home') }
  end
end
