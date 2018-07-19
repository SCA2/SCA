require 'rails_helper'

describe 'admin product options' do
  describe 'as a signed-in admin' do
    let(:admin) { create(:admin) }
    before { test_sign_in(admin, use_capybara: false) }
    
    it 'lists active and inactive options' do
      product = create(:product)
      option_1 = create(:option, product: product, active: true)
      option_2 = create(:option, product: product, active: false)
      get product_path(product)
      expect(response.body).to include(option_1.model)
      expect(response.body).to include(option_2.model)
    end

    it 'resets current_option to the first option' do
      product = create(:product)
      bom_1 = create(:bom)
      bom_2 = create(:bom)
      option_1 = create(:option, product: product, bom: bom_1, active: false)
      option_2 = create(:option, product: product, bom: bom_2, active: true)
      get product_path(product)
      expect(response.body).to include(option_1.model)
      expect(response.body).to include(option_2.model)
      expect(session[product.id][:current_option]).to eq(option_1.id)
      option_1.update(active: true)
      get product_path(product)
      expect(response.body).to include(option_1.model)
      expect(response.body).to include(option_2.model)
      expect(session[product.id][:current_option]).to eq(option_1.id)
    end
  end

  describe 'as a guest' do
    it 'only lists active options' do
      product = create(:product)
      bom_1 = create(:bom)
      bom_2 = create(:bom)
      option_1 = create(:option, product: product, bom: bom_1, active: true)
      option_2 = create(:option, product: product, bom: bom_2, active: false)
      get product_path(product)
      expect(response.body).to include(option_1.model)
      expect(response.body).not_to include(option_2.model)
    end

    it 'only lists options with boms' do
      product = create(:product)
      bom_1 = create(:bom)
      bom_2 = nil
      option_1 = create(:option, product: product, bom: bom_1, active: true)
      option_2 = create(:option, product: product, bom: bom_2, active: true)
      get product_path(product)
      expect(response.body).to include(option_1.model)
      expect(response.body).not_to include(option_2.model)
    end

    it 'only lists options with unique boms' do
      product = create(:product)
      bom_1 = create(:bom)
      bom_2 = bom_1
      option_1 = create(:option, product: product, bom: bom_1, active: true)
      option_2 = create(:option, product: product, bom: bom_2, active: true)
      get product_path(product)
      expect(response.body).not_to include(option_1.model)
      expect(response.body).to include(option_2.model)
    end

    it 'sets current_option to the first active option' do
      product = create(:product)
      bom_1 = create(:bom)
      bom_2 = create(:bom)
      option_1 = create(:option, product: product, bom: bom_1, active: true)
      option_2 = create(:option, product: product, bom: bom_2, active: true)
      get product_path(product)
      expect(response.body).to include(option_1.model)
      expect(response.body).to include(option_2.model)
      expect(session[product.id][:current_option]).to eq(option_1.id)
    end

    it 'resets current_option to the first active option' do
      product = create(:product)
      bom_1 = create(:bom)
      bom_2 = create(:bom)
      option_1 = create(:option, product: product, bom: bom_1, active: true)
      option_2 = create(:option, product: product, bom: bom_2, active: true)
      get product_path(product)
      expect(response.body).to include(option_1.model)
      expect(response.body).to include(option_2.model)
      expect(session[product.id][:current_option]).to eq(option_1.id)
      option_1.update(active: false)
      get product_path(product)
      expect(response.body).not_to include(option_1.model)
      expect(response.body).to include(option_2.model)
      expect(session[product.id][:current_option]).to eq(option_2.id)
    end
  end
end