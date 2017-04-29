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
    before { test_sign_in(admin, use_capybara: true) }

    scenario 'visit admin dashboard' do
      visit '/admin'
      expect(page).to have_title('Admin')
      expect(page).to have_content('Components')
      expect(page).to have_content('BOMs')
      expect(page).to have_content('FAQs Categories')
      expect(page).to have_content('Orders')
      expect(page).to have_content('Product Categories')
      expect(page).to have_content('Users')
    end

    scenario 'view all orders' do
      orders = []
      3.times do
        cart = create(:cart)
        order = create(:order, cart: cart)
        create(:address, addressable: order, address_type: 'billing')
        create(:address, addressable: order, address_type: 'shipping')
        create(:transaction, order: order)
        orders << order
      end
      visit '/orders'
      expect(page).to have_content(orders[0].email)
      expect(page).to have_content(orders[1].email)
      expect(page).to have_content(orders[2].email)
      click_link 'All'
      expect(page).to have_content(orders[0].email)
      expect(page).to have_content(orders[1].email)
      expect(page).to have_content(orders[2].email)
    end

    scenario 'view pending orders' do
      orders = []
      3.times do
        cart = create(:cart)
        order = create(:order, cart: cart)
        create(:address, addressable: order, address_type: 'billing')
        create(:address, addressable: order, address_type: 'shipping')
        create(:transaction, shipped_at: nil, tracking_number: nil, order: order)
        orders << order
      end
      Order.last.transactions.last.update(
        shipped_at: Date.yesterday.noon,
        tracking_number: '1ZYZV2830000000'
      )
      visit '/orders'
      click_link 'Pending'
      expect(page).to have_content(orders[0].email)
      expect(page).to have_content(orders[1].email)
      expect(page).not_to have_content(orders[2].email)
    end

    scenario 'view shipped orders' do
      orders = []
      3.times do
        cart = create(:cart)
        order = create(:order, cart: cart)
        create(:address, addressable: order, address_type: 'billing')
        create(:address, addressable: order, address_type: 'shipping')
        create(:transaction, shipped_at: nil, tracking_number: nil, order: order)
        orders << order
      end
      Order.last.transactions.last.update(
        shipped_at: Date.yesterday.noon,
        tracking_number: '1ZYZV2830000000'
      )
      visit '/orders'
      click_link 'Shipped'
      expect(page).not_to have_content(orders[0].email)
      expect(page).not_to have_content(orders[1].email)
      expect(page).to have_content(orders[2].email)
    end

    scenario 'visit a specific order' do
      3.times do
        cart = create(:cart)
        order = create(:order, cart: cart)
        product = create(:product)
        option = create(:option, price: 100, product: product)
        line_item = create(:line_item, quantity: 3, cart: cart, product: product, option: option)
        create(:billing, addressable: order)
        create(:shipping, addressable: order)
        create(:transaction, order: order)
      end
      visit '/orders'
      click_link Order.last.id
      expect(page).to have_content('$300.00')
    end

    scenario 'send ship notification email' do
      product = create(:product)
      option = create(:option, product: product)
      cart = create(:cart)
      create(:line_item, cart: cart, product: product, option: option)
      order = create(:order, cart: cart)
      create(:billing, addressable: order)
      create(:shipping, addressable: order)
      create(:transaction, order: order)
      visit '/orders'
      click_link 'ship'
      expect(page).to have_content('Tracking number')
      fill_in 'Tracking number', with: '1ZYZV2830000000'
      click_button 'Send'
      expect(page).to have_title('Orders')
      expect(page).to have_content('Tracking number sent!')
      expect(order.transactions.last.tracking_number).to eq('1ZYZV2830000000')
      expect(DateTime.current.in_time_zone.minus_with_coercion(order.transactions.last.shipped_at)).to be < 1
    end

    scenario 'view orders between dates', :vcr do
      orders = []
      3.times do
        cart = create(:cart)
        order = create(:order, cart: cart)
        create(:address, addressable: order, address_type: 'billing')
        create(:address, addressable: order, address_type: 'shipping')
        create(:transaction, order: order)
        orders << order
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

    scenario 'delete abandoned orders' do
      cart = create(:cart)
      order = create(:order, cart: cart)
      create(:address, addressable: order, address_type: 'billing')
      create(:address, addressable: order, address_type: 'shipping')
      visit '/orders'
      expect(page).to have_title('Orders')
      expect(page).to have_content('Delete Abandoned')
      expect { click_link 'Delete Abandoned' }.to change(Order, :count).by(-1)
    end

    scenario 'does not delete completed orders' do
      cart = create(:cart)
      order = create(:order, cart: cart)
      create(:address, addressable: order, address_type: 'billing')
      create(:address, addressable: order, address_type: 'shipping')
      create(:transaction, order: order)
      visit '/orders'
      expect(page).to have_title('Orders')
      expect(page).to have_content('Delete Abandoned')
      expect { click_link 'Delete Abandoned' }.to change(Order, :count).by(0)
    end

    scenario 'view sales tax', :vcr do
      3.times do
        product = create(:product)
        option = create(:option, price: 100, product: product)
        line_item = create(:line_item, quantity: 1, product: product, option: option)
        cart = create(:cart, line_items: [line_item])
        cart.update(purchased_at: "01/01/2016".to_date.noon)
        order = create(:order, shipping_cost: 1500, cart: cart)
        create(:address, addressable: order, address_type: 'shipping')
        create(:address, addressable: order, address_type: 'billing', state_code: 'CA')
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