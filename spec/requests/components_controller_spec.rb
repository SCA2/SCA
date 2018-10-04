require 'rails_helper'

describe 'admin components' do
  describe 'as a signed-in admin' do
    let(:admin) { create(:admin) }
    before { test_sign_in(admin, use_capybara: false) }
    
    it 'renders component index' do
      component_1 = create(:component)
      component_2 = create(:component)
      get components_path
      expect(response.body).to include(component_1.mfr_part_number)
      expect(response.body).to include(component_2.mfr_part_number)
    end

    it 'delete alerts if component is used in a product' do
      component = create(:component)
      option = create(:option, component: component)
      delete component_path(component)
      expect(flash[:alert]).to include('Cannot delete record')
    end

    it 'delete alerts if component is used in a cart' do
      component = create(:component)
      line_item = create(:line_item, component: component)
      delete component_path(component)
      expect(flash[:alert]).to include('Cannot delete record')
    end

    it 'delete alerts if component is used in a bom' do
      component = create(:component)
      bom_item = create(:bom_item, component: component)
      delete component_path(component)
      expect(flash[:alert]).to include('Cannot delete record')
    end
  end

  describe 'as a guest' do

    let(:component) { create(:component) }

    it 'index redirects to products path' do
      get components_path
      expect(response).to redirect_to home_path
    end

    it 'create redirects to products path' do
      post components_path
      expect(response).to redirect_to home_path
    end

    it 'new redirects to products path' do
      get new_component_path
      expect(response).to redirect_to home_path
    end

    it 'edit redirects to products path' do
      get edit_component_path(component)
      expect(response).to redirect_to home_path
    end

    it 'show redirects to products path' do
      get component_path(component)
      expect(response).to redirect_to home_path
    end

    it 'update redirects to products path' do
      patch component_path(component)
      expect(response).to redirect_to home_path
    end

    it 'delete redirects to products path' do
      delete component_path(component)
      expect(response).to redirect_to home_path
    end
  end
end