require 'rails_helper'

describe 'admin product options' do
  describe 'as a signed-in admin' do
    let(:admin) { create(:admin) }
    before { test_sign_in(admin, use_capybara: false) }
    
    it 'lists active and inactive options' do
      product = create(:product)
      tag_1 = create(:constant_tag)
      tag_2 = create(:constant_tag)
      component_1 = create(:component, size_weight_price_tag: tag_1)
      component_2 = create(:component, size_weight_price_tag: tag_2)
      option_1 = create(:option, product: product, component: component_1, active: true)
      option_2 = create(:option, product: product, component: component_2, active: false)
      get product_path(product)
      expect(response.body).to include(option_1.model)
      expect(response.body).to include(option_2.model)
    end

    it 'resets current_option to the first option' do
      product = create(:product)
      tag_1 = create(:size_weight_price_tag)
      tag_2 = create(:size_weight_price_tag)
      component_1 = create(:component, size_weight_price_tag: tag_1)
      component_2 = create(:component, size_weight_price_tag: tag_2)
      option_1 = create(:option, product: product, component: component_1, active: false)
      option_2 = create(:option, product: product, component: component_2, active: true)
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
    
    describe "delete" do
      let(:product) { create(:product) }
      let(:option)  { create(:option, product: product) }

      it "destroys the requested option" do
        option.save!
        expect {
          delete product_option_path(product, option)
        }.to change(Option, :count).by(-1)
      end
    
      it "redirects to the product page" do
        delete product_option_path(product, option)
        expect(response).to redirect_to(product)
      end
    end
  end

  describe 'as a guest' do
    it 'only lists active options' do
      product = create(:product)
      tag_1 = create(:size_weight_price_tag)
      tag_2 = create(:size_weight_price_tag)
      component_1 = create(:component, size_weight_price_tag: tag_1)
      component_2 = create(:component, size_weight_price_tag: tag_2)
      option_1 = create(:option, product: product, component: component_1, active: true)
      option_2 = create(:option, product: product, component: component_2, active: false)
      get product_path(product)
      expect(response.body).to include(option_1.model)
      expect(response.body).not_to include(option_2.model)
    end

    it 'sets current_option to the first active option' do
      product = create(:product)
      tag_1 = create(:size_weight_price_tag)
      tag_2 = create(:size_weight_price_tag)
      component_1 = create(:component, size_weight_price_tag: tag_1)
      component_2 = create(:component, size_weight_price_tag: tag_2)
      option_1 = create(:option, product: product, component: component_1, active: true)
      option_2 = create(:option, product: product, component: component_2, active: true)
      get product_path(product)
      expect(response.body).to include(option_1.model)
      expect(response.body).to include(option_2.model)
      expect(session[product.id][:current_option]).to eq(option_1.id)
    end

    it 'resets current_option to the first active option' do
      product = create(:product)
      tag_1 = create(:size_weight_price_tag)
      tag_2 = create(:size_weight_price_tag)
      component_1 = create(:component, size_weight_price_tag: tag_1)
      component_2 = create(:component, size_weight_price_tag: tag_2)
      option_1 = create(:option, product: product, component: component_1, active: true)
      option_2 = create(:option, product: product, component: component_2, active: true)
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