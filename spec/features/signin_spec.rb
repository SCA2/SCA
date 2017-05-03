require 'rails_helper'

describe "Sign In" do
  it "signs in user with email and password" do
    user = create(:user)
    visit signin_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "Password confirmation", with: user.password
    click_button "Sign in"
    expect(current_path).to eq(user_path(user))
    expect(page).to have_content(user.name)
    expect(page).to have_content(user.email)
    expect(page).to have_content('Edit Profile')
  end

  it "does not sign in user without password confirmation" do
    user = create(:user)
    visit signin_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "Password confirmation", with: ''
    click_button "Sign in"
    expect(page).to have_content("Password confirmation doesn't match Password")
    expect(page).to have_content("Password confirmation can't be blank")
  end

  it "does not sign in user with wrong password" do
    user = create(:user)
    visit signin_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password + 'x'
    fill_in "Password confirmation", with: user.password + 'x'
    click_button "Sign in"
    expect(page).to have_content("Invalid email or password")
  end
end