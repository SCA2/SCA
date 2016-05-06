module ProductsHelper

  def get_extended_models(product)
    extended_models = {}
    product.options.each do |option|
      if option.active? || signed_in_admin?
        extended_models[product.model + option.model + ', ' + option.description + ', ' + get_price(option)] = option.id
      end
    end
    extended_models
  end

  def get_extended_model(product, option)
    extended_model = product.model + option.model + ', ' + option.description
  end

  def first_in_category?(products, product)
    if products && product
      category = product.category
      sort_order = product.model_sort_order
      return !products.where('category = ? and model_sort_order < ?', category, sort_order).exists?
    end
  end

  def last_in_category?(products, product)
    if products && product
      category = product.category
      sort_order = product.model_sort_order
      return !products.where('category = ? and model_sort_order > ?', category, sort_order).exists?
    end
  end
  
  def get_price(option)
    cents_to_dollars(option.price_in_cents, precision: 0)
  end
  
  def get_product_div_class(counter)
    div_class = "product small"
    if counter.even?
      div_class << " even"
    else
      div_class << " odd"
    end
    return ("class=" << "'" << div_class << "'").html_safe
  end
  
end
