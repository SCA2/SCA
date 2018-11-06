module OrdersHelper

  def crumb_class(path)
    if current_page?(path)
      "current"
    elsif session[:progress] && session[:progress].include?(path)
      "available"
    else
      "disabled"
    end
  end

  def crumb_link(label, path)
    state = crumb_class(path)
    if state == "disabled"
      return label
    else
      return link_to(label, path)
    end
  end

  def make_radio_button(rate, index)
    erb_string = "f.radio_button :shipping_method, ship_method, checked: false"
    if @order.shipping_method
      if (rate.service_name == @order.shipping_method)
        erb_string = "f.radio_button :shipping_method, ship_method, checked: true"
      end
    elsif (index == 0)
        erb_string = "f.radio_button :shipping_method, ship_method, checked: true"
    end
    erb_string
  end

  def cents_to_dollars(cents, options = {precision: 0})
    number_to_currency(cents.to_f / 100, options) 
  end

end
