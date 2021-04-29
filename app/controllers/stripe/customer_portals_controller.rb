class Stripe::CustomerPortalsController < ApplicationController
  def create
    begin
      customer_session = Stripe::BillingPortal::Session.create({
        customer: current_user.stripe_customer_id,
        return_url: root_url
      })
      render json: customer_session.to_json
    rescue => e
      render json: { message: e.message }.to_json, status: 400
    end
  end
end
