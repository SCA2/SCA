require 'rails_helper'

feature "BOMs" do
  
  context "as a guest" do
    let(:bom) { build_stubbed(:bom) }
    scenario 'view index' do
      visit boms_path
      expect(page).to have_content("admins only")
    end
    scenario 'edit BOM' do
      visit edit_bom_path(bom)
      expect(page).to have_content("admins only")
    end
    scenario 'delete BOM' do
      visit boms_path
      expect(page).to have_content("admins only")
    end
  end

  context "as an admin" do

    let(:admin) { create(:admin) }
    before      { test_sign_in admin }
    after(:all) { DatabaseCleaner.clean_with(:truncation) }

    scenario 'view boms index' do
      component = create(:component)
      bom = create(:bom, component: component)
      visit '/admin'
      click_link('BOMs', match: :first)
      expect(page).to have_content(bom.component.mfr_part_number)
    end

    scenario 'add a new BOM' do
      component = create(:component)
      bom = build_stubbed(:bom, component: component)
      visit boms_path
      expect(page).to have_selector(:link_or_button, 'New BOM')
      first(:link_or_button, 'New BOM').click
      expect(page).to have_content('Root Component')
      find('#bom_creator_root_component').find(:xpath, 'option[1]').select_option
      find(:link_or_button, 'Create').click
      expect(page).to have_content("BOM #{component.mfr_part_number} created")
      expect(page).to have_content(bom.component.mfr_part_number)
    end

    scenario 'view bom edit page' do
      component = create(:component)
      bom = create(:bom, component: component)
      visit edit_bom_path(bom)
      expect(page).to have_content(component.mfr_part_number)
    end

    scenario 'update an existing BOM' do
      component = create(:component)
      bom = create(:bom, component: component)
      create(:bom_item, bom: bom)
      visit boms_path
      find(:link_or_button, bom.id).click
      expect(page).to have_content("BOM #{bom.component.mfr_part_number}")
      find(:link_or_button, 'Edit').click
      find(:link_or_button, 'Update').click
      expect(page).to have_content("BOM #{bom.component.mfr_part_number} updated")
    end

    scenario 'add a component to a BOM' do
      root = create(:component)
      bom = create(:bom, component: root)
      component = create(:component)
      item = build_stubbed(:bom_item, quantity: 2, reference: 'R1', component: component)
      visit new_item_bom_path(bom)
      fill_in_bom_item(item)
      find(:link_or_button, 'Update').click
      expect(page).to have_content("2")
    end

    scenario 'delete a BOM' do
      component = create(:component)
      bom = create(:bom, component: component)
      bom_id = bom.id
      visit boms_path
      expect { click_link 'delete' }.to change(Bom, :count).by(-1)
    end
  end
end
