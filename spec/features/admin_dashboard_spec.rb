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
    before { test_sign_in(user, use_capybara: true) }
    
    scenario 'visit admin dashboard' do
      visit '/admin'
      expect(page).to have_title('Admin')
      expect(page).to have_content('Please log in')
    end
  end

  context 'as a signed-in admin' do
    let(:admin) { create(:admin) }
    let(:cart) { create(:cart) }

    before { test_sign_in(admin, use_capybara: true) }
    scenario 'visit admin dashboard' do
      visit '/admin'
      expect(page).to have_title('Admin')
      expect(page).to have_content('View Users')
      expect(page).to have_content('View Orders')
      expect(page).to have_content('View FAQs')
      expect(page).to have_content('View Components')
    end

    scenario 'view orders', :vcr do
      orders = []
      3.times do |n|
        cart = create(:cart)
        orders[n] = create(:order, cart: cart)
        orders[n].addresses << create(:address, addressable: orders[n], address_type: 'billing')
        orders[n].addresses << create(:address, addressable: orders[n], address_type: 'shipping')
        create(:transaction, order: orders[n])
      end
      visit '/orders'
      expect(page).to have_content(orders[0].email)
      expect(page).to have_content(orders[1].email)
      expect(page).to have_content(orders[2].email)
    end

    scenario 'visit a specific order' do
      3.times do |n|
        product = create(:product)
        option = create(:option, price: 100, product: product)
        line_item = create(:line_item, quantity: n + 1, product: product, option: option)
        cart = create(:cart, line_items: [line_item])
        order = create(:order, cart: cart)
        order.addresses << create(:address, addressable: order, address_type: 'billing')
        order.addresses << create(:address, addressable: order, address_type: 'shipping')
        create(:transaction, order: order)
      end
      visit '/orders'
      click_link Order.last.id
      expect(page).to have_content('$300.00')
    end

    scenario 'view orders between dates', :vcr do
      orders = []
      3.times do |n|
        cart = create(:cart)
        orders[n] = create(:order, cart: cart)
        orders[n].addresses << create(:address, addressable: orders[n], address_type: 'billing')
        orders[n].addresses << create(:address, addressable: orders[n], address_type: 'shipping')
        create(:transaction, order: orders[n])
      end
      orders[0].cart.update(purchased_at: Date.current.in_time_zone - 1.day)
      orders[1].cart.update(purchased_at: Date.current.in_time_zone)
      orders[2].cart.update(purchased_at: Date.current.in_time_zone + 1.day)
      visit '/orders'
      expect(page).to have_content('From:')
      expect(page).to have_content('To:')
      click_button 'Search'
      expect(page).not_to have_content(orders[0].email)
      expect(page).to have_content(orders[1].email)
      expect(page).not_to have_content(orders[2].email)
    end

    scenario 'delete abandoned orders', :vcr do
      order = create(:order, cart: cart)
      order.addresses << create(:address, addressable: order, address_type: 'billing')
      order.addresses << create(:address, addressable: order, address_type: 'shipping')
      visit '/orders'
      expect(page).to have_title('Orders')
      expect(page).to have_content('Delete abandoned')
      expect { click_link 'Delete abandoned' }.to change(Order, :count).by(-1)
    end

    scenario 'does not delete completed orders', :vcr do
      order = create(:order, cart: cart)
      order.addresses << create(:address, addressable: order, address_type: 'billing')
      order.addresses << create(:address, addressable: order, address_type: 'shipping')
      create(:transaction, order: order)
      visit '/orders'
      expect(page).to have_title('Orders')
      expect(page).to have_content('Delete abandoned')
      expect { click_link 'Delete abandoned' }.to change(Order, :count).by(0)
    end

    scenario 'view sales tax', :vcr do
      3.times do
        product = create(:product)
        option = create(:option, price: 100, product: product)
        line_item = create(:line_item, quantity: 1, product: product, option: option)
        cart = create(:cart, line_items: [line_item])
        cart.update(purchased_at: "01/01/2016".to_date.noon)
        order = create(:order, shipping_cost: 1500, cart: cart)
        order.addresses << create(:address, addressable: order, address_type: 'shipping')
        order.addresses << create(:address, addressable: order, address_type: 'billing', state_code: 'CA')
        create(:transaction, order: order)
      end
      visit '/admin'
      fill_in 'from', with: '01/01/2016'
      fill_in 'to', with: '31/03/2016'
      click_button 'Calculate Sales Tax'
      expect(page).to have_title('Sales Tax')
      within('div.sales-tax') { expect(page).to have_content('374') }
      within('div.sales-tax') { expect(page).to have_content('45') }
      within('div.sales-tax') { expect(page).to have_content('29') }
    end
  end
end