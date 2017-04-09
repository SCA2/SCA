require "rails_helper"

describe Checkout::AddressesController do
  describe :routing do
    it { expect(get('/checkout/1/addresses/new')).to route_to('checkout/addresses#new', checkout_id: '1') }
    it { expect(post('/checkout/1/addresses')).to route_to('checkout/addresses#create', checkout_id: '1') }
  end
end

describe Checkout::ShippingController do
  describe :routing do
    it { expect(get('/checkout/1/shipping/new')).to route_to('checkout/shipping#new', checkout_id: '1') }
    it { expect(patch('/checkout/1/shipping')).to route_to('checkout/shipping#update', checkout_id: '1') }
    it { expect(put('/checkout/1/shipping')).to route_to('checkout/shipping#update', checkout_id: '1') }
  end
end

describe Checkout::ConfirmationController do
  describe :routing do
    it { expect(get('/checkout/1/confirmation/new')).to route_to('checkout/confirmation#new', checkout_id: '1') }
    it { expect(patch('/checkout/1/confirmation')).to   route_to('checkout/confirmation#update', checkout_id: '1') }
    it { expect(put('/checkout/1/confirmation')).to     route_to('checkout/confirmation#update', checkout_id: '1') }
  end
end

describe Checkout::PaymentController do
  describe :routing do
    it { expect(get('/checkout/1/payment/new')).to  route_to('checkout/payment#new', checkout_id: '1') }
    it { expect(patch('/checkout/1/payment')).to    route_to('checkout/payment#update', checkout_id: '1') }
  end
end

describe Checkout::TransactionsController do
  describe :routing do
    it { expect(get('/checkout/1/transactions/new')).to route_to('checkout/transactions#new', checkout_id: '1') }
  end
end