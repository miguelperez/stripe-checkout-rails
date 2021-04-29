class Stripe::SuccessCheckoutsController < ApplicationController
  def show
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @customer = Stripe::Customer.retrieve(@session.customer)
  end
end
