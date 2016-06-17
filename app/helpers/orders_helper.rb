module OrdersHelper

  def get_crumb_class(path)
    if current_page?(path)
      "current"
    elsif session[:progress].include?(path)
      "available"
    else
      "unavailable"
    end
  end

  def crumb_class(path)
    html_text = "class='"
    html_text << get_crumb_class(path)
    html_text << "'"
    return html_text.html_safe
  end

  def crumb_link(label, path)
    state = get_crumb_class(path)
    if state == "unavailable"
      return link_to(label, '#')
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
