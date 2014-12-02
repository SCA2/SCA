include ApplicationHelper

def test_sign_in(user, use_capybara = true)
  if use_capybara
    visit signin_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "Password confirmation", with: user.password
    click_button "Sign in"
  else
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    @current_user = user
  end
end

def fill_in_product(product)
  fill_in "Model:", with: product.model
  fill_in "Model Sort Order:", with: product.model_sort_order
  select product.category, from: "Category:"
  fill_in "Category Sort Order:", with: product.category_sort_order
  fill_in "Short Description:", with: product.short_description
  fill_in "Long Description:", with: product.long_description
  fill_in "Notes:", with: product.notes
  fill_in "Image_1 URL:", with: product.image_1
  fill_in "Image_2 URL:", with: product.image_2
  fill_in "Specifications URL:", with: product.specifications
  fill_in "Schematic URL:", with: product.schematic
  fill_in "BOM URL:", with: product.bom
  fill_in "Assembly Instructions URL:", with: product.assembly
end

def fill_in_option(option)
  fill_in "Option:", with: option.model
  fill_in "Description:", with: option.description
  fill_in "Price:", with: option.price
  fill_in "UPC:", with: option.upc
  fill_in "Shipping Weight:", with: option.shipping_weight
  fill_in "Kit Stock:", with: option.kit_stock
  fill_in "Part Stock:", with: option.part_stock
  fill_in "Sort Order:", with: option.sort_order
  fill_in "Discount:", with: option.discount
  fill_in "Shipping Length:", with: option.shipping_length
  fill_in "Shipping Width:", with: option.shipping_width
  fill_in "Shipping Height:", with: option.shipping_height
  fill_in "Assembled Stock:", with: option.assembled_stock
  fill_in "Partial Stock:", with: option.partial_stock
end

def fill_in_feature(feature)
  fill_in "Model:", with: feature.model
  fill_in "Caption:", with: feature.caption
  fill_in "Sort Order:", with: feature.sort_order
  fill_in "Description:", with: feature.description
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert-box.alert', text: message)
  end
end

RSpec::Matchers.define :not_have_error_message do
  match do |page|
    expect(page).to_not have_selector('div.alert-box.alert')
  end
end

RSpec::Matchers.define :require_signin do |expected|
  match do |actual|
    # expect(actual).to redirect_to Rails.application.routes.url_helpers.signin_path
    expect(actual).to redirect_to signin_path
  end
  failure_message do |actual|
    "expected to require signin to access the method"
  end
  failure_message_when_negated do |actual|
    "expected not to require signin to access the method"
  end
  description do
    "redirect to the signin form"
  end
end