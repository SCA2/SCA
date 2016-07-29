require 'rails_helper'

describe PaypalRedirector do
  context 'with valid express token' do
    it 'returns paypal express url' do
      order = build_stubbed(:order, express_token: 'EC-54F541285X6896103')
      expect(PaypalRedirector.url(order)).to include('cmd=_express-checkout&token=EC-54F541285X6896103')
    end
  end
  context 'with invalid express token' do
    it 'returns nil' do
      order = build_stubbed(:order, express_token: '')
      expect(PaypalRedirector.url(order)).to be nil
    end
  end
  context 'with order already purchased' do
    it 'returns nil' do
      order = double(:order)
      allow(order).to receive(:purchased?).and_return(true)
      expect(PaypalRedirector.url(order)).to be nil
    end
  end
  context 'with missing order' do
    it 'returns nil' do
      expect(PaypalRedirector.url(nil)).to be nil
    end
  end
end