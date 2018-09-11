module ProductsHelper

  def get_extended_models(product)
    extended_models = {}
    product.options.sorted.each do |option|
      if option.enabled? || signed_in_admin?
        extended_models[option.model + ', ' + option.description + ', ' + get_price(option)] = option.id
      end
    end
    extended_models
  end

  def get_extended_model(product, option)
    extended_model = product.model + option.model + ', ' + option.description
  end

  def get_price(option)
    cents_to_dollars(option.full_price_in_cents, precision: 0)
  end
  
  def get_product_div_class(counter)
    div_class = "product small"
    if counter.even?
      div_class << " even"
    else
      div_class << " odd"
    end
    div_class.html_safe
  end

  def visible?(obj)
    obj.active? || signed_in_admin?
  end
  
end
