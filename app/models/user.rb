class User < ActiveRecord::Base

  has_many :payments
  has_many :subscriptions

  validates :stripe_uid, uniqueness: true, allow_nil: true
  validates :url_handle, uniqueness: true, allow_nil: true
  validates :email, uniqueness: true, allow_nil: true
  validate :must_have_at_least_1_subscription

  before_validation :create_free_subscription, on: :create

  mount_uploader :avatar, AvatarUploader

  def self.find_or_create_from_oauth(auth, current_user = nil)
    # user clicked demo dashboard, then connect stripe but they already have account
    # because have registered and connected stripe before
    user = where("stripe_uid" => auth.uid).first

    # user is coming from demo account and finishing sign up by connecting stripe
    user = current_user if user.nil?

    # user is registering from the homepage for the first time
    user = User.new if user.nil?

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
