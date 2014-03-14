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

end
