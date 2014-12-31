class Subscription < ActiveRecord::Base

  # 0 - free (limit: 200)
  # 1 - $9 (limit: 2000)
  # 2 - $15 (unlimited)
  PLANS = [0, 1, 2]

  belongs_to :user
  has_many :subscription_payments

  validates :plan, inclusion: { in: PLANS }, presence: true
  validates :user, presence: true

  # how much transactions volume is left
  # returns false if unlimited
  def remaining_limit
    return false unless current_plan_limit
    limit = (current_plan_limit - transactions_last_32_days).round
    limit < 0 ? 0 : limit
  end

  def transactions_last_32_days
    user.payments.last_32_days.successful.sum(:amount)
  end

  def current_plan_limit
    return 200   if plan === 0
    return 2000  if plan === 1
    return false if plan === 2
  end

  def paid?
    if plan === 0
      true
    else
      subscription_payments.where("created_at >= ?", 32.days.ago).present?
    end
  end
end
