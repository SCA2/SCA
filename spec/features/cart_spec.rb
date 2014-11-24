require 'rails_helper'

feature "Shopping Cart" do
  context "as a guest" do
    scenario 'page contains cart links' do
      visit home_path
      expect(page).to have_content 'Log In'
      expect(page).to have_content '0 Items'
    end
  end
end
