require 'spec_helper'

feature "Shopping Cart" do
  context "as a guest" do
    scenario 'page contains cart links' do
      visit home_path
      expect(page).to have_content 'Sign In'
      expect(page).to have_content '0 Items'
      expect(page).to have_content 'Checkout'
    end
  end
end
