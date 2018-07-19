require 'rails_helper'

feature "faq category" do
  
  context "as a guest" do
    let(:faqs_category) { build_stubbed(:faqs_category) }
    scenario 'view index' do
      visit faqs_categories_path
      expect(page).to have_content("admins only")
    end
    scenario 'edit faq category' do
      visit edit_faqs_category_path(faqs_category)
      expect(page).to have_content("admins only")
    end
    scenario 'delete faq category' do
      visit faqs_categories_path
      expect(page).to have_content("admins only")
    end
  end

  context "as an admin" do

    let(:admin) { create(:admin) }
    before      { test_sign_in(admin,use_capybara: true) }
    after(:all) { DatabaseCleaner.clean_with(:truncation) }

    scenario 'view faq categories index' do
      faqs_category = create(:faqs_category)
      visit '/admin'
      click_link('FAQs Categories', match: :first)
      expect(page).to have_content(faqs_category.category_name)
      expect(page).to have_content(faqs_category.category_weight)
    end

    scenario 'add a new faq category' do
      faqs_category = build_stubbed(:faqs_category)
      visit faqs_categories_path
      expect(page).to have_selector(:link_or_button, 'New FAQ Category')
      first(:link_or_button, 'New FAQ Category').click
      expect(page).to have_content('New FAQ Category')
      fill_in_faqs_category(faqs_category)
      find(:link_or_button, 'Create').click
      expect(page).to have_content("FAQs Category #{faqs_category.category_name} created")
    end

    scenario 'view faqs_category edit page' do
      faqs_category = create(:faqs_category)
      visit edit_faqs_category_path(faqs_category)
      expect(page).to have_field("Category Name:", with: faqs_category.category_name)
      expect(page).to have_field("Category Weight:", with: faqs_category.category_weight)
    end

    scenario 'update an existing faq category' do
      faqs_category = create(:faqs_category)
      visit faqs_categories_path
      expect(page).to have_content("#{faqs_category.category_name}")
      find(:link_or_button, 'edit').click
      fill_in_faqs_category(faqs_category)
      find(:link_or_button, 'Update').click
      expect(page).to have_content("FAQs Category #{faqs_category.category_name} updated")
    end

    scenario 'delete a faq category' do
      faqs_category = create(:faqs_category)
      bom_id = faqs_category.id
      visit faqs_categories_path
      expect { click_link 'delete' }.to change(FaqsCategory, :count).by(-1)
    end
  end
end
