class FeedbackMailer < ActionMailer::Base
  default :from => "Bodo Studio <contact@apocrypharius.com>"
  
  def feedback_email
    @description = params[:description].gsub("\r\n", "<br>").html_safe
    puts @description
    @subject = 'Contact Form - ' + params[:email] + " - " + DateTime.now.strftime("%-d-%b-%Y %H:%M hr EST")
    @email = params[:email]    
    mail(to: "contact@apocrypharius.com", subject: @subject, template_path: 'mailers/templates', template_name: 'feedback')
  end
end