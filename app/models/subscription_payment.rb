class SubscriptionPayment < ActiveRecord::Base

  belongs_to :subscription

  validates :subscription, presence: true
end
