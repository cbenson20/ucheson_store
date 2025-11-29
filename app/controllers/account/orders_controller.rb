class Account::OrdersController < ApplicationController
  before_action :authenticate_user!

  # Order history page (Rubric 3.2.1)
  def index
    @orders = current_user.orders.order(created_at: :desc).page(params[:page]).per(10)
  end

  # Order detail page
  def show
    @order = current_user.orders.find(params[:id])
    @province = @order.address.province
  end
end