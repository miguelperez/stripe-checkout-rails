class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :subscription

  def create_stripe_customer!
    self.stripe_customer_id = Stripe::Customer.create({
      email: self.email,
    }).id
    self.save
  end

  def provision_stripe_subscription!(event)
    self.build_subscription(data: event.to_h)
    self.save!
  end

end
