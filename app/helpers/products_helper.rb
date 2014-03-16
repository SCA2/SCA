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
end
