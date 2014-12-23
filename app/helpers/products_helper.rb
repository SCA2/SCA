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
  
  def get_stock(option)
    option.assembled_stock.to_s
  end

  def get_price(option)
    number_to_currency(option.price, precision: 0)
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
  
  def set_current_option(product, params)
    option_id = params[:options].to_i
    begin
      session[product.id][:current_option] = option_id
    rescue
      initialize_session_option(product)
    end
    return_option(product, option_id)
  end

  def get_current_option(product)
    option_id = 0
    begin
      option_id = session[product.id][:current_option].to_i
    rescue
      initialize_session_option(product)
    end
    return_option(product, option_id)
  end

  def initialize_session_option(product)
    session[product.id] = {}
    session[product.id][:current_option] = product.options.first.id
    option_id = session[product.id][:current_option].to_i
  end

  def return_option(product, option_id)
    if product.options.exists?(option_id)
      product.options.find(option_id)
    else
      product.options.first
    end
  end

end
