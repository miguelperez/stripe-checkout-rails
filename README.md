# Welcome

Simple stripe checkout implementation in Rails.

## Contents

### Controllers

The application has the following controllers:

- **Stripe/checkout_sessions** <br>
Used to create the session to subscribe the user

- **Stripe/success_checkout** <br>
Used to handle the success checkout

- **Stripe/cancelled_checkout** <br>
Used to handle the cancelled checkout

- **home** <br>
Used to show a page with the plans

### Models

- **User** <br>
Regular devise user model with the addition of a stripe_customer_id.

- **Subscription** <br>
After a user subscribes, this model holds the data of this users subscription on stripe.

- **Plan** <br>
Used to model the same products and prices we have on stripe.

