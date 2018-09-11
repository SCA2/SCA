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

  it "updates the user password when confirmation matches" do
    
    user = create(:user,
      password_reset_token: "reset_token",
      password_reset_sent_at: 1.hour.ago
    )
    
    visit edit_password_reset_path(user.password_reset_token)
    expect(page).to have_content("Change Password")
    fill_in "user_password", with: "foobar"
    fill_in "user_password_confirmation", with: "foobar"
    click_button "Save Password"
    expect(page).to have_content("Password reset!")
  end

  it "reports when password token has expired" do
    user = create(:user, :password_reset_token => "something", :password_reset_sent_at => 3.hour.ago)
    visit edit_password_reset_path(user.password_reset_token)
    fill_in "user_password", :with => "foobar"
    fill_in "user_password_confirmation", :with => "foobar"
    click_button "Save Password"
    expect(page).to have_content("Reset link has expired!")
  end

  it "redirects to home page with bad reset token" do
    visit edit_password_reset_path(0)
    expect(page).to have_title("Home")
  end
end