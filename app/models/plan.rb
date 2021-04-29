# frozen_string_literal: true

class Plan
  PRODUCTS = {
    products: [{ id: 'premium_a_xyz',
                 code_name: 'premium_a',
                 name: 'Premium 150',
                 items: 200,
                 description: 'Premium Plan',
                 prices: [{ unit_amount: 15_000,
                            recurring: { interval: 'month' },
                            id: 'price_0IlEZWiURBS9uSKQPZRx3x1r' },
                          { unit_amount: 10_000,
                            recurring: { interval: 'year' },
                            id: 'price_0IlEZXiURBS9uSKQM72F6myn' }] },
               { id: 'premium_b_xyz',
                 code_name: 'premium_b',
                 name: 'Premium 350',
                 items: 500,
                 description: 'Premium Plan',
                 prices: [{ unit_amount: 32_500,
                            recurring: { interval: 'month' },
                            id: 'price_0IlEZXiURBS9uSKQJXt0Nh5G' },
                          { unit_amount: 25_000,
                            recurring: { interval: 'year' },
                            id: 'price_0IlEZYiURBS9uSKQpwDCvQAy' }] },
               { id: 'premium_c_xyz',
                 code_name: 'premium_c',
                 name: 'Premium 750',
                 items: 1000,
                 description: 'Premium Plan',
                 prices: [{ unit_amount: 65_000,
                            recurring: { interval: 'month' },
                            id: 'price_0IlEZYiURBS9uSKQnhYgblgp' },
                          { unit_amount: 50_000,
                            recurring: { interval: 'year' },
                            id: 'price_0IlEZZiURBS9uSKQ9YZnQbrV' }] }]
  }.freeze

  class << self
    def all
      RecursiveOpenStruct.new(PRODUCTS, recurse_over_arrays: true).products
    end

    def reject(recurrence)
      all.map do |product|
        data = product.dup
        data.prices.delete_if { |price| price.recurring.interval == recurrence }
        data
      end
    end

    def monthly
      reject('year')
    end

    def yearly
      reject('month')
    end
  end
end
