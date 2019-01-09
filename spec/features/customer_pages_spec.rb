require 'rails_helper'

feature 'customer lists dashboard' do
  context 'as a guest' do
    scenario 'visit customer lists dashboard' do
      visit '/customers'
      expect(page).to have_title('Home')
    end
  end

  context 'as a signed-in user' do
    let(:user) { create(:user) }
    before { test_sign_in(user, use_capybara: true) }
    
    scenario 'visit customer lists' do
      visit '/customers'
      expect(page).to have_title('Home')
    end
  end

  context 'as a signed-in admin' do
    let(:registered) { create(:user) }
    let(:admin) { create(:admin) }
    before { test_sign_in(admin, use_capybara: true) }

    scenario 'visit customer lists' do
      visit '/customers'
      expect(page).to have_title('Customer Lists')
      expect(page).to have_content('All')
      expect(page).to have_content('Registered')
      expect(page).to have_content('Guests')
    end

    scenario 'view all customers' do
      orders = []
      order = create(:order, email: 'guest@example.com')
      create(:address, addressable: order, address_type: 'billing')
      orders << order
      order = create(:order, email: registered.email)
      create(:address, addressable: order, address_type: 'billing')
      orders << order

      visit '/customers'
      expect(page).to have_content('guest@example.com')
      expect(page).to have_content(registered.email)
    end

    scenario 'view authenticated customers' do
      orders = []
      order = create(:order, email: 'guest@example.com')
      create(:address, addressable: order, address_type: 'billing')
      orders << order
      order = create(:order, email: registered.email)
      create(:address, addressable: order, address_type: 'billing')
      orders << order

      visit '/customers'
      click_link('Registered', match: :first)
      expect(page).to have_content(registered.email)
      expect(page).not_to have_content('guest@example.com')
    end

    scenario 'view guest customers' do
      orders = []
      order = create(:order, email: 'guest@example.com')
      create(:address, addressable: order, address_type: 'billing')
      orders << order
      order = create(:order, email: registered.email)
      create(:address, addressable: order, address_type: 'billing')
      orders << order

      visit '/customers'
      click_link('Guests', match: :first)
      expect(page).not_to have_content(registered.email)
      expect(page).to have_content('guest@example.com')
    end
  end
end