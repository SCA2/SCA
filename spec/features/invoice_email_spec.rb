require 'rails_helper'

describe "Send invoice notification" do
  before do
    tag = create(:size_weight_price_tag)
    component = create(:component, size_weight_price_tag: tag)
    option = create(:option, component: component)
    visit products_path
    first(:button, 'Add to Cart').click
    @cart = Cart.last
  end

  it "is not available to user" do
    user = create(:user)
    test_sign_in(user, use_capybara: true)
    visit cart_path(@cart)
    expect(page).to have_content("1 Item")
    expect(page).not_to have_content("Create Invoice")
  end

  it "is only available to admin" do
    admin = create(:admin)
    test_sign_in(admin, use_capybara: true)
    visit cart_path(@cart)
    expect(page).to have_content("1 Item")
    expect(page).to have_content("Create Invoice")
  end

  it "collects customer name and email address" do
    admin = create(:admin)
    user = create(:user)
    test_sign_in(admin, use_capybara: true)
    visit cart_path(@cart)
    click_link "Create Invoice"
    fill_in "Name", with: user.name
    fill_in "Email", with: user.email
    click_button "Send"
    expect(current_path).to eq(invoices_path)
    expect(page).to have_content("Invoice sent")
    expect(last_email.to).to include(user.email)
    expect(last_email.body.encoded).to include(user.name)
    expect(last_email.body.encoded).to include('Subtotal')
  end
end