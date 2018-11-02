module AlertsHelper

  def alert_div_class(name)
    div_class = case name
      when 'success' then 'success'
      when 'notice' then 'warning'
      else 'alert'
    end
    return div_class.html_safe
  end

end