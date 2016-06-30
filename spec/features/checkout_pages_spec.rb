require 'rails_helper'

feature 'standard checkout', :vcr, js: true do
  before(:each) do
    @credit_card = {
      card_type: 'Visa',
      card_number: '4032038036005571',
      expiration_month: '12',
      expiration_year: '2019',
      cvv: '123',
      email: 'sales-buyer@seventhcircleaudio.com'
    }

    @state = 'California'
    @address = build(:billing_constant_taxable)
    @product = create(:n72)
    create(:feature, product: @product)
    create(:ka, product: @product)
  end

  after(:each) { DatabaseCleaner.clean_with(:truncation) }

  scenario 'as a guest' do
    visit product_path(@product)
    click_button('Add to Cart')
    expect(page).to have_content('1 Items')
    visit cart_path(Cart.last)
    click_link('Checkout')
    expect(Order.count).to eq(1)
    expect(page).to have_content('Billing Address')
    expect(page).to have_content('Shipping Address')
    fill_in_billing
    fill_in_shipping
    click_button('Continue Checkout')
    expect(page).to have_content('UPS Options')
    find("input[id^='order_shipping_method_ups_ground']").click
    click_button('Continue Checkout')
    expect(page).to have_content(@product.options.last.model)
    check('order_terms_validator_accept_terms')
    click_button('Continue Checkout')
    expect(page).to have_content('Card Info')
    fill_in_credit_card
    click_button('Place Order')
    expect(page).to have_content('Transaction ID')
  end

  scenario 'as a signed-in user' do
    user = create(:user)
    create(:billing_constant_taxable, addressable: user)
    create(:shipping_constant_taxable, addressable: user)
    test_sign_in(user, true)

    visit product_path(@product)
    click_button('Add to Cart')
    expect(page).to have_content('1 Items')
    visit cart_path(Cart.last)
    click_link('Checkout')
    expect(Order.count).to eq(1)
    expect(page).to have_field("order_addresses_attributes_0_address_1",
      with: user.addresses.first.address_1)
    expect(page).to have_field("order_addresses_attributes_1_address_1",
      with: user.addresses.last.address_1)
    click_button('Continue Checkout')
    expect(page).to have_content('UPS Options')
    find("input[id^='order_shipping_method_ups_ground']").click
    click_button('Continue Checkout')
    expect(page).to have_content(user.addresses.first.address_1)
    expect(page).to have_content(user.addresses.last.address_1)
    expect(page).to have_content('UPS Ground')
    expect(page).to have_content(@product.options.last.model)
    check('order_terms_validator_accept_terms')
    click_button('Continue Checkout')
    expect(page).to have_content('Card Info')
    fill_in_credit_card
    click_button('Place Order')
    expect(page).to have_content('Transaction ID')
    test_sign_out(true)
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
      select(@state, from: 'order_addresses_attributes_0_state_code')
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
      select(@state, from: 'order_addresses_attributes_1_state_code')
    end
  end

  def fill_in_credit_card
    within('fieldset#payment') do
      select(@credit_card[:card_type], from: 'card_validator_card_type')
      fill_in('card_validator_card_number', with: @credit_card[:card_number])
      fill_in('card_validator_card_verification', with: @credit_card[:cvv])
      select(@credit_card[:expiration_month], from: 'card_validator_card_expires_on_2i')
      select(@credit_card[:expiration_year], from: 'card_validator_card_expires_on_1i')
      fill_in('card_validator_email', with: @credit_card[:email])
    end
  end
end