require 'rails_helper'

describe "PasswordResets" do
  it "emails user when requesting password reset" do
    user = create(:user)
    visit signin_path
    click_link "Forgot your password?"
    fill_in "Email", :with => user.email
    click_button "Reset Password"
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Password reset instructions sent!")
    expect(last_email.to).to include(user.email)
  end

  it "does not email invalid user when requesting password reset" do
    visit signin_path
    click_link "password"
    fill_in "Email", :with => "nobody@example.com"
    click_button "Reset Password"
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Password reset instructions sent!")
    expect(last_email).to be_nil
  end

  it "updates the user password when confirmation matches" do
    
    user = create(:user,
      password_reset_token: "reset_token",
      password_reset_sent_at: 1.hour.ago
    )
    
    visit edit_password_reset_path(user.password_reset_token, email: user.email)
    expect(page).to have_content("Change Password")
    fill_in "Password", with: "foobar"
    fill_in "Confirm", with: "foobar"
    click_button "Save Password"
    expect(page).to have_content("Password reset!")
  end

  it "reports when password token has expired" do
    user = create(:user, password_reset_token: "something", password_reset_sent_at: 3.hours.ago)
    visit edit_password_reset_path(user.password_reset_token, email: user.email)
    expect(page).to have_content("reset link has expired!")
  end

  it "redirects to home page with bad reset token" do
    visit edit_password_reset_path(0)
    expect(page).to have_title("Home")
  end
end