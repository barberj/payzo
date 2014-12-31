# encoding: UTF-8

class MarketingMailer < ActionMailer::Base

  default from: "\"Sergey\" <sergey@payzo.io>"
  layout nil

  def opinion_v_1(email)
    mail to: email, subject: "Do you accept credit cards?"
  end
end
