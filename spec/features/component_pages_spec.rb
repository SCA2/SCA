require 'rails_helper'

feature "Components" do
  
  context "as a guest" do
    let(:component) { build_stubbed(:component) }
    scenario 'view index' do
      visit components_path
      expect(page).to have_content("admins only")
    end
    scenario 'edit component' do
      visit edit_component_path(component)
      expect(page).to have_content("admins only")
    end
    scenario 'delete component' do
      visit components_path
      expect(page).to have_content("admins only")
    end
  end

  context "as an admin" do

    let(:admin) { create(:admin) }
    before      { test_sign_in(admin, use_capybara: true) }
    after(:all) { DatabaseCleaner.clean_with(:truncation) }

    scenario 'view components index' do
      component = create(:component)
      visit '/admin'
      click_link 'View Components'
      expect(page).to have_content(component.mfr_part_number)
    end

    scenario 'view component page' do
      component = create(:component)
      visit edit_component_path(component)
      expect(page).to have_field('Mfr', with: component.mfr)
      expect(page).to have_field('Mfr Part Number', with: component.mfr_part_number)
      expect(page).to have_field('Vendor', with: component.vendor)
      expect(page).to have_field('Vendor Part Number', with: component.vendor_part_number)
      expect(page).to have_field('Value', with: component.value)
      expect(page).to have_field('Marking', with: component.marking)
      expect(page).to have_field('Description', with: component.description)
    end

    scenario 'add a new component' do
      component = build_stubbed(:component)
      visit components_path
      expect(page).to have_selector(:link_or_button, 'New Component')
      first(:link_or_button, 'New Component').click
      expect(page).to have_content('New Component')
      fill_in_component(component)
      find(:link_or_button, 'Update').click
      expect(page).to have_content("Component #{component.mfr_part_number} created")
      expect(page).to have_content(component.mfr_part_number)
    end

    scenario 'update an existing component' do
      component = create(:component)
      visit components_path
      first(:link_or_button, component.mfr_part_number).click
      expect(page).to have_content("Component #{component.mfr_part_number}")
      component.marking = 'unique marking'
      fill_in_component(component)
      find(:link_or_button, 'Update').click
      expect(page).to have_content("Component #{component.mfr_part_number} updated")
      expect(page).to have_content('unique marking')
    end

    scenario 'delete a component' do
      component = create(:component)
      visit components_path
      expect { click_link 'delete' }.to change(Component, :count).by(-1)
    end
  end
end
