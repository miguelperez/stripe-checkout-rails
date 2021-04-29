class Stripe::WebhooksController < ApplicationController
  before_action :check_stripe_request!
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    # Get the type of webhook event sent
    event_type = @event['type']
    data = @event['data']
    data_object = data['object']

    case event_type
    when 'checkout.session.completed'
      # Payment is successful and the subscription is created.
      # You should provision the subscription and save the customer ID to your database.
      if data_object.payment_status == 'paid'
        fulfill_order(data_object)
      end
    when 'checkout.session.async_payment_succeeded'
      fulfill_order(data_object)
    when 'invoice.paid'
      # Continue to provision the subscription as payments continue to be made.
      # Store the status in your database and check when a user accesses your service.
      # This approach helps you avoid hitting rate limits.
    when 'invoice.payment_failed'
      # The payment failed or the customer does not have a valid payment method.
      # The subscription becomes past_due. Notify your customer and send them to the
      # customer portal to update their payment information.
    else
      puts "Unhandled event type: #{@event.type}"
    end

    render plain: 'ok', status: 200
  end

  private

  def fulfill_order(checkout_session)
    User.where(stripe_customer_id: checkout_session.customer).take.provision_stripe_subscription!(checkout_session)
  end

  def check_stripe_request!
    webhook_secret = 'whsec_TTy6C0tIssPIZJ7Osm0eVD2t6gSbOiXj' # ENV['STRIPE_WEBHOOK_KEY']
    payload = request.body.read
    # Retrieve the event by verifying the signature using the raw body and secret if webhook signing is configured.
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    @event = nil
    begin
      @event = Stripe::Webhook.construct_event(payload, sig_header, webhook_secret)
    rescue JSON::ParserError => e
      # Invalid payload
      render plain: 'bad', status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      puts 'Webhook signature verification failed.'
      render plain: 'bad', status: 400
      return
    end
  end
end
