require 'rails_helper'

feature 'Checkout' do
  context "as a guest" do

    before(:all) do
      @state = 'California'
      @address = build(:billing_constant_taxable)
      @product = create(:n72)
      create(:feature, product: @product)
      create(:ka, product: @product)

      @credit_card = {
        card_type: 'Visa',
        card_number: '4032038036005571',
        expiration_month: '12',
        expiration_year: '2019',
        cvv: '123',
        email: 'sales-buyer@seventhcircleaudio.com'
      }
    end

    after(:all) { DatabaseCleaner.clean_with(:truncation) }

    scenario 'add product to cart' do
      visit products_path
      first(:button, 'Add to Cart').click
      expect(page).to have_content('1 Items')
    end

    scenario 'standard checkout', :vcr do
      visit products_path
      first(:button, 'Add to Cart').click
      expect(page).to have_content('1 Items')
      visit cart_path(Cart.last)
      click_link('Checkout')
      expect(Order.count).to eq(1)
      expect(page).to have_content('Billing Address')
      expect(page).to have_content('Shipping Address')
      fill_in_billing
      fill_in_shipping
      click_button('Continue Checkout')
      fill_in_state
      click_button('Continue Checkout')
      expect(page).to have_content('UPS Options')
      find("input[id^='order_shipping_method_ups_ground']").click
      click_button('Continue Checkout')
      expect(page).to have_content(@product.options.last.model)
      check('order_accept_terms')
      click_button('Continue Checkout')
      expect(page).to have_content('Card Info')
      fill_in_credit_card
      click_button('Place Order')
      expect(page).to have_content('Transaction ID')
    end
  end

  context "as a signed-in user" do
  end

  def fill_in_billing
    within('div#billing') do
      fill_in('First name', with: @address.first_name)
      fill_in('Last name', with: @address.last_name)
      fill_in('Address 1', with: @address.address_1)
      fill_in('Address 2', with: @address.address_2)
      fill_in('City', with: @address.city)
      first('#order_addresses_attributes_0_country option').select_option
      fill_in('Post Code', with: @address.post_code)
      fill_in('Telephone', with: @address.telephone)
    end
  end

  def fill_in_shipping  
    within('div#shipping') do
      fill_in('First name', with: @address.first_name)
      fill_in('Last name', with: @address.last_name)
      fill_in('Address 1', with: @address.address_1)
      fill_in('Address 2', with: @address.address_2)
      fill_in('City', with: @address.city)
      first('#order_addresses_attributes_1_country option').select_option
      fill_in('Post Code', with: @address.post_code)
      fill_in('Telephone', with: @address.telephone)
    end
  end

  def fill_in_state
    select(@state, from: 'order_addresses_attributes_0_state_code')
    select(@state, from: 'order_addresses_attributes_1_state_code')
  end

  def fill_in_credit_card
    within('fieldset#payment') do
      select(@credit_card[:card_type], from: 'order_card_type')
      fill_in('order_card_number', with: @credit_card[:card_number])
      fill_in('order_card_verification', with: @credit_card[:cvv])
      select(@credit_card[:expiration_month], from: 'order_card_expires_on_2i')
      select(@credit_card[:expiration_year], from: 'order_card_expires_on_1i')
      fill_in('order_email', with: @credit_card[:email])
    end
  end
end