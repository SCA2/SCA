# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feature do
    model "MyString"
    caption "MyString"
    short_description "MyText"
    long_description "MyText"
  end
end
