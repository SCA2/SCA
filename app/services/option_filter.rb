class OptionFilter

  attr_reader :options

  def initialize(product_id)
    product = Product.find(product_id)
    @options = product.options if product
  end

end