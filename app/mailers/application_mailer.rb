class ApplicationMailer < ActionMailer::Base

  default from: "sales@seventhcircleaudio.com"
  default return_path: "sales@seventhcircleaudio.com"
  default date: Time.now.asctime
  default content_type: "text/html"

end