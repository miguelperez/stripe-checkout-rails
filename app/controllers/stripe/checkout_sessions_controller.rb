class Stripe::CheckoutSessionsController < ApplicationController
  def create
    begin
      checkout_session = Stripe::Checkout::Session.create(
        customer: current_user.stripe_customer_id,
        success_url: "#{stripe_success_checkouts_url}?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: "#{stripe_cancelled_checkouts_url}?session_id={CHECKOUT_SESSION_ID}",
        payment_method_types: ['card'],
        mode: 'subscription',
        line_items: [{
          quantity: 1,
          price: params[:price_id],
        }],
      )
      render json: checkout_session.to_json
    rescue => e
      render json: { message: e.message }.to_json, status: 400
    end
  end
end
