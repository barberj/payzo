class PaymentsController < ApplicationController

  def index
    @payments = current_user.payments.all
  end

  def show
    # @secure_id: To prevent users from guessing numeric IDs to display payments that are not theirs
    @payment = Payment.where(secure_id: params[:id]).first
  end

  def new
    @recipient_user = User.find_by_url_handle!(params[:handle])
    @payment = @recipient_user.payments.new
    @remaining_limit = @recipient_user.current_subscription.remaining_limit
  end

  def create
    @recipient_user = User.find(payment_params[:user_id])
    @payment = Payment.new(payment_params)

    if @payment.save
      if process_payment(payment_params[:amount], params[:stripeToken], payment_params[:name], payment_params[:email], @recipient_user)
        if @payment.update_attribute(:success, true)
          UserMailer.payment_received(@recipient_user, @payment).deliver
          UserMailer.payment_sent(@recipient_user, @payment).deliver
          redirect_to payment_url(@payment.secure_id) and return
        end
      else
        render :new, alert: "Payment could not have been processed"
      end
    else
      render :new, alert: "Payment was not sent"
    end

    render :new
  end

private

  def payment_params
    params.require(:payment).permit(:message, :name, :email, :amount, :user_id)
  end

  def process_payment(amount, token, payer_name, payer_email, recipient_user)
    begin
      charge = Stripe::Charge.create(
        {
          amount: (amount.to_f * 100).to_i, # amount in cents
          currency: "usd",
          card: token,
          description: payer_email,
          statement_descriptor: payer_name[0..21]
        }, recipient_user.stripe_access_token
      )
    rescue Stripe::CardError => e
      return false
    end
  end
end
