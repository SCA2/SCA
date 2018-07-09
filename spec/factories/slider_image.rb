# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :slider_image do
    sequence(:name)         { |n| "Product #{n}" }
    sequence(:caption)      { |n| "Caption #{n}" }
    sequence(:image_url)    { |n| "/assets/image-#{n}.jpg"}
    sequence(:product_url)  { |n| "/assets/product-#{n}.com"}
    sequence(:sort_order)   { |n| "#{(n % 100) + 1}"}
  end
end

