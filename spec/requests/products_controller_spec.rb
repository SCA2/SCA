require 'rails_helper'

describe 'access to products' do
  describe 'as a signed-in admin' do
    let(:admin) { create(:admin) }
    before { test_sign_in(admin, use_capybara: false) }

    describe 'GET index' do
      it 'lists active and inactive products' do
        p1 = create(:product, model: 'ABC', active: true)
        p2 = create(:product, model: 'XYZ', active: false)
        create(:option, product: p1)
        create(:option, product: p2)
        get products_path
        expect(response.body).to include("/products/#{p1.model}")
        expect(response.body).to include("/products/#{p2.model}")
      end
    end
  end

  describe 'as a guest' do
    describe 'GET index' do
      it 'only lists active products' do
        p1 = create(:product, model: 'ABC', active: true)
        p2 = create(:product, model: 'XYZ', active: false)
        create(:option, product: p1)
        create(:option, product: p2)
        get products_path
        expect(response.body).to include("/products/#{p1.model}")
        expect(response.body).to_not include("/products/#{p2.model}")
      end
    end
  end
end