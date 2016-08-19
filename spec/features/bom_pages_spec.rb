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
      bom = create(:bom)
      visit '/admin'
      click_link 'View BOMs'
      expect(page).to have_content(bom.revision)
    end

    scenario 'add a new BOM' do
      product = create(:product, model: 'A12')
      bom = build_stubbed(:bom, product: product)
      visit boms_path
      expect(page).to have_selector(:link_or_button, 'New BOM')
      first(:link_or_button, 'New BOM').click
      expect(page).to have_content('New BOM')
      fill_in_bom(bom)
      find(:link_or_button, 'Create').click
      expect(page).to have_content("BOM #{product.model} Rev #{bom.revision} created")
      expect(page).to have_content(bom.product.model)
    end

    scenario 'view bom edit page' do
      product = create(:product, model: 'A12')
      bom = create(:bom, product: product, revision: '1.0', pdf: 'url')
      visit edit_bom_path(bom)
      expect(page).to have_select('Product')
      expect(page).to have_content('A12')
      expect(page).to have_field('Revision', with: '1.0')
      expect(page).to have_field('PDF URL', with: 'url')
    end

    scenario 'update an existing BOM' do
      product = create(:product, model: 'A12')
      option = create(:option, product: product)
      bom = create(:bom, product: product, revision: '1.0', pdf: 'url')
      visit boms_path
      find(:link_or_button, bom.id).click
      expect(page).to have_content("BOM #{bom.product.model} Rev #{bom.revision}")
      find(:link_or_button, 'Edit').click
      bom.pdf = 'new pdf url'
      fill_in_bom(bom)
      find(:link_or_button, 'Update').click
      expect(page).to have_content("BOM #{bom.product.model} Rev #{bom.revision} updated")
      expect(page).to have_field('PDF URL', with: 'new pdf url')
    end

    scenario 'add a component to a BOM' do
      product = create(:product, model: 'A12')
      option = create(:option, product: product)
      bom = create(:bom, product: product, revision: '1.0', pdf: 'url')
      component = create(:component)
      item = build_stubbed(:bom_item, quantity: 2, reference: 'R1', component: component)
      visit new_item_bom_path(bom)
      fill_in_bom_item(item)
      find(:link_or_button, 'Update').click
    end

    scenario 'delete a BOM' do
      bom = create(:bom)
      bom_id = bom.id
      visit boms_path
      expect { click_link 'delete' }.to change(Bom, :count).by(-1)
    end
  end
end
