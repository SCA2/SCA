require 'rails_helper'

describe ErrorPagesController do
  context 'url contains no product name' do
    it 'redirects to product index' do
      get :unknown, params: { id: 'bogus' }
      expect(response).to render_template(file: "#{Rails.root}/public/404.html")
    end
  end

  context 'url contains a product name' do
    it 'redirects to product page' do
      product = create(:n72)
      create(:ka, product: product)
      get :unknown, params: { id: 'asdfn72asdf' }
      expect(response).to redirect_to product
    end
  end
end