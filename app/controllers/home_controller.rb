class HomeController < ApplicationController
  def index
    @products = Plan::PRODUCTS
    @monthly = Plan.monthly
    @yearly = Plan.yearly
  end

  def show
  end
end
