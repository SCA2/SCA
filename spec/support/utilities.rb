include ApplicationHelper

def valid_signin(user)
  fill_in "Email:", with: user.email.upcase
  fill_in "Password:", with: user.password
  fill_in "Confirm:", with: user.password
  click_button "Sign in"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert-box', text: message)
  end
end

RSpec::Matchers.define :not_have_error_message do
  match do |page|
    expect(page).to_not have_selector('div.alert-box')
  end
end
