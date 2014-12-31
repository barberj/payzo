class User < ActiveRecord::Base

  has_many :payments
  has_many :subscriptions

  validates :stripe_uid, presence: true, uniqueness: true
  validates :url_handle, uniqueness: true, allow_nil: true
  validates :email, uniqueness: true, allow_nil: true
  validate :must_have_at_least_1_subscription

  before_validation :create_free_subscription, on: :create

  mount_uploader :avatar, AvatarUploader

  def self.find_or_create_from_oauth(auth)
    user = where("stripe_uid" => auth.uid).first_or_initialize
    user.stripe_uid= auth.uid
    user.stripe_access_token = auth.credentials.token
    user.stripe_pub_key = auth.info.stripe_publishable_key
    user.tap(&:save!)
  end

  def current_subscription
    subscriptions.order(:created_at).last
  end

private

  def must_have_at_least_1_subscription
    errors.add(:subscriptions, "must have at least 1") if subscriptions.size < 1
  end

  def create_free_subscription
    self.subscriptions.new(plan: 0)
  end
end
