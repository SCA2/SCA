module OptionsHelper

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