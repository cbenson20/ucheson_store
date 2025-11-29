class Account::DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @recent_orders = current_user.orders.order(created_at: :desc).limit(5)
    @addresses = current_user.addresses
  end
end