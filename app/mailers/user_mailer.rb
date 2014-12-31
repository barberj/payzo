# encoding: UTF-8

class UserMailer < ActionMailer::Base

  default from: "\"payzo.io\" <no-reply@payzo.io>"
  layout "mailer"

  def payment_received(recipient_user, payment)
    @payment = payment
    @user = recipient_user
    mail to: @user.email, subject: "Payment from #{@payment.name}"
  end

  def payment_sent(recipient_user, payment)
    @payment = payment
    @recipient_user = recipient_user
    mail to: @payment.email, subject: "Payment sent"
  end
end
