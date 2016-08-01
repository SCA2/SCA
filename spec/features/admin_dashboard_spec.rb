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
    let(:cart) { create(:cart) }

    before { test_sign_in admin }
    scenario 'visit admin dashboard' do
      visit '/admin'
      expect(page).to have_title('Admin')
      expect(page).to have_content('View Users')
      expect(page).to have_content('View Orders')
      expect(page).to have_content('View FAQs')
    end

    scenario 'view orders', :vcr do
      orders = []
      3.times do |n|
        cart = create(:cart)
        orders[n] = create(:order, cart: cart)
        orders[n].addresses << build(:address, addressable: orders[n], address_type: 'billing')
        orders[n].addresses << build(:address, addressable: orders[n], address_type: 'shipping')
        orders[n].save
        orders[n].addresses.each { |address| address.save }
        create(:transaction, order: orders[n])
      end
      visit '/orders'
      expect(page).to have_content(orders[0].email)
      expect(page).to have_content(orders[1].email)
      expect(page).to have_content(orders[2].email)
    end

    scenario 'visit a specific order' do
      2.times do
        cart = create(:cart)
        order = create(:order, cart: cart)
        order.addresses << build(:address, addressable: order, address_type: 'billing')
        order.addresses << build(:address, addressable: order, address_type: 'shipping')
        order.save
        order.addresses.each { |address| address.save }
        create(:transaction, order: order)
      end
      visit '/orders'
      click_link Order.first.id
      expect(page).to have_content(Order.first.billing_address.first_name)
    end

    scenario 'view orders between dates', :vcr do
      orders = []
      3.times do |n|
        cart = create(:cart)
        orders[n] = build(:order, cart: cart)
        orders[n].addresses << build(:address, addressable: orders[n], address_type: 'billing')
        orders[n].addresses << build(:address, addressable: orders[n], address_type: 'shipping')
        orders[n].save
        orders[n].addresses.each { |address| address.save }
        create(:transaction, order: orders[n])
      end
      orders[0].cart.purchased_at = Date.current.in_time_zone - 1.day
      orders[0].cart.save
      orders[1].cart.purchased_at = Date.current.in_time_zone
      orders[1].cart.save
      orders[2].cart.purchased_at = Date.current.in_time_zone + 1.day
      orders[2].cart.save
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
      order.addresses << build(:address, addressable: order, address_type: 'billing')
      order.addresses << build(:address, addressable: order, address_type: 'shipping')
      order.save
      order.addresses.each { |address| address.save }
      visit '/orders'
      expect(page).to have_title('Orders')
      expect(page).to have_content('Delete abandoned')
      expect { click_link 'Delete abandoned' }.to change(Order, :count).by(-1)
    end

    scenario 'does not delete completed orders', :vcr do
      order = build(:order, cart: cart)
      order.addresses << build(:address, addressable: order, address_type: 'billing')
      order.addresses << build(:address, addressable: order, address_type: 'shipping')
      order.save
      order.addresses.each { |address| address.save }
      create(:transaction, order: order)
      visit '/orders'
      expect(page).to have_title('Orders')
      expect(page).to have_content('Delete abandoned')
      expect { click_link 'Delete abandoned' }.to change(Order, :count).by(0)
    end

    scenario 'view sales tax', :vcr do
      orders = []
      3.times do |n|
        product = create(:product)
        option = create(:option, price: 100, product: product)
        line_item = create(:line_item, quantity: 1, product: product, option: option)
        cart = create(:cart, line_items: [line_item])
        cart.update(purchased_at: "01/01/2016".to_date.noon)
        orders[n] = build(:order, shipping_cost: 1500, cart: cart)
        orders[n].addresses << build(:address, addressable: orders[n], address_type: 'shipping')
        orders[n].addresses << build(:address, addressable: orders[n], address_type: 'billing', state_code: 'CA')
        orders[n].save
        orders[n].addresses.each { |address| address.save }
        create(:transaction, order: orders[n])
      end
      # byebug
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