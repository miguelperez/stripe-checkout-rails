namespace :stripe do
  desc "Create stripe Prices"
  task generate_products: :environment do
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']

    products_data = Plan.all.dup

    products_data.each do |product_data|
      stripe_product = Stripe::Product.create({id: product_data.id, name: product_data.name, description: product_data.description})

      puts "Product ID: #{stripe_product.id}"

      product_data.prices.each do |price_data|
        price_data.delete_field(:id)
        stripe_price =Stripe::Price.create(
          price_data.to_h.merge({
            currency: 'usd',
            product: stripe_product.id,
          })
        )
        price_data.id = stripe_price.id
        puts "Price ID: #{stripe_price.id} - #{stripe_price.recurring.interval}"
      end
      puts '- - -'
    end

    pp products_data.map(&:to_h)
  end

end
