require 'rails_helper'

feature 'admin dashboard' do
  context 'as a guest' do
    scenario 'visit admin dashboard' do
      visit '/admin'
      expect(page).to have_title('Admin')
      expect(page).to have_content('Please log in')
    end
  end

  context 'as a signed-in user' do
    let(:user) { create(:user) }
    before { test_sign_in user }
    
    scenario 'visit admin dashboard' do
      visit '/admin'
      expect(page).to have_title('Admin')
      expect(page).to have_content('Please log in')
    end
  end

  context 'as a signed-in admin' do
    let(:admin) { create(:admin) }
    before { test_sign_in admin }

    scenario 'visit admin dashboard' do
      visit '/admin'
      expect(page).to have_title('Admin')
      expect(page).to have_content('View Users')
      expect(page).to have_content('View Orders')
      expect(page).to have_content('View FAQs')
    end
  end
end