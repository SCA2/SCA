require "rails_helper"

describe Checkout::ExpressController do
  describe :routing do
    it { expect(get('/checkout/1/express/new')).to route_to('checkout/express#new', checkout_id: '1') }
    it { expect(get('/checkout/1/express/edit')).to route_to('checkout/express#edit', checkout_id: '1') }

    it { expect(post('/checkout/1/express')).to_not be_routable }
    it { expect(put('/checkout/1/express/1')).to_not be_routable }
    it { expect(get('/checkout/1/express')).to route_to('error_pages#unknown', id: 'checkout/1/express') }
    it { expect(get('/checkout/1/express/1')).to route_to('error_pages#unknown', id: 'checkout/1/express/1') }
    it { expect(delete('/checkout/1/express')).to_not be_routable }
  end
end

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
    it { expect(get('/checkout/1/payment/edit')).to route_to('checkout/payment#edit', checkout_id: '1') }
    it { expect(post('/checkout/1/payment')).to     route_to('checkout/payment#create', checkout_id: '1') }
  end
end

describe Checkout::TransactionsController do
  describe :routing do
    it { expect(get('/checkout/1/transactions/new')).to route_to('checkout/transactions#new', checkout_id: '1') }
  end
end