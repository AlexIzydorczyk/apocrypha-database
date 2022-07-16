class MailersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:send_feedback]

	def send_feedback
    description = params[:description]
  	email = params[:email]

    FeedbackMailer.with(description: description, email: email).feedback_email.deliver_now
    unless params[:no_flash]
      flash[:notice] = "Email sent. You will hear from us soon."
      redirect_back(fallback_location: root_path)
    end
	end
end
