class AlertMailer < ApplicationMailer
    def trigger_email
        @alert = params[:alert]
        @user = @alert.user
        @price = params[:price]

        mail(to: @user.email, subject: 'Your alert was triggered!')
      end
end
