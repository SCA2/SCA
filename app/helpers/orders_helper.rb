module OrdersHelper

  def get_crumb_class(path)
    if session[:progress].last == path
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

end
