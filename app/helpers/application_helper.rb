module ApplicationHelper

  def auth_token
    "<input type=\"hidden\"
      name=\"authenticity_token\"
      value=\"#{form_authenticity_token}\">".html_safe
  end

  def status_messages
    if flash[:notice]
      "<p class=\"notice\">#{flash[:notice]}</p>".html_safe
    elsif flash[:error]
      "<p class=\"error\">#{flash[:error]}</p>".html_safe
    end
  end
end
