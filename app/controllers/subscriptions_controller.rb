class SubscriptionsController < ApplicationController

  before_filter :require_login, only: [:new, :create, :destroy]
  protect_from_forgery :except => :webhook

  def new
    if current_user.current_subscription.plan == 0
      @label_free = 'Currently'
      @label_starter = 'Upgrade'
      @label_pro = 'Upgrade'
    elsif current_user.current_subscription.plan == 1
      @label_free = 'Downgrade'
      @label_starter = 'Currently'
      @label_pro = 'Upgrade'
    elsif current_user.current_subscription.plan == 2
      @label_free = 'Downgrade'
      @label_starter = 'Downgrade'
      @label_pro = 'Currently'
    end

    @have_customer_details = current_user.stripe_customer_id.present?
  end

  # TODO: display stripe card form only for the first time subscription is entered
  # for updating, canceling, downgrading or repeated upgrading, don't display it
  def create
    # ensure Stripe customer id (and their card details) is saved
    stripe_customer = nil
    card_error = false

    if current_user.stripe_customer_id.nil?
      if params[:stripeToken]
        begin
          stripe_customer = Stripe::Customer.create(
            :card => params[:stripeToken],
            :email => current_user.email
          )
          current_user.update_attribute(:stripe_customer_id, stripe_customer.id)
        rescue => e
          console.log(e)
          logger.debug(e)
          flash[:alert] = "Your card could not be authorised. Plese check your card limits and try again."
          card_error = true
        end
      else
        console.log("stripeToken not provided")
        logger.debug("stripeToken not provided")
        flash[:alert] = "Your card could not be authorised. Plese check your card limits and try again."
        card_error = true
      end
    else
      stripe_customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
    end

    head 402 and return if card_error

    # create or update their subscriptions plan
    plan = Plan::OPTIONS.select { |opt| opt[:id].to_s === params[:plan_id].to_s }.first

    if plan.present?
      stripe_subscription = nil

      # customer already has stripe_id = update
      if current_user.current_subscription.stripe_id
        stripe_subscription = stripe_customer.subscriptions.retrieve(current_user.current_subscription.stripe_id)
        stripe_subscription.plan = plan[:name].downcase
        stripe_subscription.save

      # customer doesn't have stripe_id = new subscription, not update
      else
        stripe_subscription = stripe_customer.subscriptions.create(plan: plan[:name].downcase)
      end

      Subscription.create!(plan: plan[:id], user: current_user, stripe_id: stripe_subscription.id).subscription_payments.create!
      redirect_to :back
    else
      raise "Invalid plan id"
    end
  end

  # Downgrade to a free plan
  def destroy
    # cancel monthly stripe subscription
    stripe_customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
    stripe_customer.subscriptions.retrieve(current_user.current_subscription.stripe_id).delete

    # update subscription records in our database
    current_user.subscriptions.create!(plan: 0)

    redirect_to :back
  end

  # Called by Stripe when new monthly charge happens
  def webhook
    # create a new subscription payment
    # current_user.current_subscription.subscription_payments.create!
    console.log params
    puts params
    render json: params
  end
end
