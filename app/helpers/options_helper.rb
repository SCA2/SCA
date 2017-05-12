module OptionsHelper

  def set_current_option(product, params)
    option_id = params[:options].to_i
    session[product.id][:current_option] = option_id
    if signed_in_admin?
      product.options.find(option_id)
    else
      product.active_options.find(option_id)
    end
  rescue
    initialize_session_option(product)
  end

  def get_current_option(product)
    option_id = session[product.id][:current_option].to_i
    if signed_in_admin?
      return product.options.find(option_id)
    else
      return product.active_options.find(option_id)
    end
  rescue
    initialize_session_option(product)
  end

  def initialize_session_option(product)
    session[product.id] = {}
    if signed_in_admin? && product && product.options && product.options.first
      option = product.options.first
      session[product.id][:current_option] = option.id
    elsif product && product.active_options && product.active_options.first
      option = product.active_options.first
      session[product.id][:current_option] = option.id
    end
    option
  end

end