module AlertsHelper

  def get_alert_div_class(name)
    div_class = case name
      when 'notice' then 'success'
      when 'success' then 'success'
      else 'alert'
    end
    return ("class='alert-box " << div_class << "'").html_safe
  end

end
