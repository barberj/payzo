class Payment < ActiveRecord::Base

  belongs_to :user

  validate :name, presence: true
  validate :email, presence: true
  validate :amount, presence: true, numericality: { greater_than: 0 }
  validate :user, presence: true
  validate :validate_amount_limit

  before_validation :set_secure_id, on: :create
  scope :last_32_days, -> { where("created_at >= ?", 32.days.ago) }
  scope :successful, -> { where("success is true") }

private

  # To prevent users from guessing numeric IDs to display payments that are not theirs
  def set_secure_id
    self.secure_id = SecureRandom.hex(32)
    self.secure_id = SecureRandom.hex(32) until !self.class.find_by_secure_id(self.secure_id)
  end

  def validate_amount_limit
    if self.user.current_subscription.remaining_limit
      errors.add(:amount, "Exceeds the allowed limit") if self.user.current_subscription.remaining_limit < self.amount
    end
  end
end
