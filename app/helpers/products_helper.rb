module ProductsHelper

  def get_extended_models(product)
    extended_models = {}
    product.options.each do |option|
      extended_models[product.model + option.model + ', ' + option.description] = option.id
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
  
  def get_stock(product)
    product.options.find(product.current_option).assembled_stock.to_s
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

  def get_current_option(product)
    option = 0
    if product.options.any?
      if session[product.id].nil?
        option = product.options.first.id.to_i
      else
        option = session[product.id][:current_option].to_i
      end
    end
    option
  end

end
