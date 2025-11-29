class OrdersController < ApplicationController
  before_action :set_provinces, only: [:new]

  # Checkout form - collect address and province (Rubric 3.1.3)
  def new
    if current_cart.empty?
      flash[:alert] = "Your cart is empty. Please add some items before checkout."
      redirect_to products_path and return
    end

    @provinces = Province.all.order(:name)
    @cart_items = []
    @cart_total = 0

    # Load cart items
    current_cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      if product
        @cart_items << {
          product: product,
          quantity: quantity,
          line_total: product.price * quantity
        }
        @cart_total += product.price * quantity
      end
    end

    # Pre-fill form if user is logged in
    if user_signed_in?
      @user = current_user
      @address = current_user.addresses.where(address_type: 'shipping').last || current_user.addresses.build
    end
  end

  # Process order (Rubric 3.1.3, 3.3.2)
  def create
    if current_cart.empty?
      flash[:alert] = "Your cart is empty."
      redirect_to products_path and return
    end

    # Get province for tax calculation
    province = Province.find_by(id: params[:province_id])
    unless province
      flash[:alert] = "Please select a valid province."
      redirect_to new_order_path and return
    end

    # Use logged-in user or create guest user (Rubric 3.1.4)
    if user_signed_in?
      user = current_user
    else
      user = User.find_or_create_by(email: params[:email]) do |u|
        u.username = params[:email].split('@').first
        u.first_name = params[:first_name]
        u.last_name = params[:last_name]
        # Set a random password for guest users
        u.password = SecureRandom.hex(10)
      end
    end

    # Create or find address
    address = Address.create!(
      user: user,
      province: province,
      street_address: params[:street_address],
      city: params[:city],
      postal_code: params[:postal_code],
      address_type: 'shipping'
    )

    # Calculate totals
    subtotal = 0
    current_cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      if product
        subtotal += product.price * quantity
      end
    end

    tax_amount = subtotal * province.total_tax_rate
    total = subtotal + tax_amount

    # Create order (Rubric 3.3.2 - preserves historical prices)
    @order = Order.create!(
      user: user,
      address: address,
      status: 'pending',
      subtotal: subtotal,
      tax_amount: tax_amount,
      total: total
    )

    # Create order items with current prices (Rubric 3.3.2)
    current_cart.each do |product_id, quantity|
      product = Product.find_by(id: product_id)
      if product
        # Check stock availability
        if product.stock_quantity < quantity
          flash[:alert] = "Sorry, #{product.name} is out of stock."
          @order.destroy
          redirect_to cart_path and return
        end

        # Create order item with current price (historical price preservation)
        OrderItem.create!(
          order: @order,
          product: product,
          quantity: quantity,
          price_at_purchase: product.price  # Rubric 3.3.2 - saves current price
        )

        # Reduce stock quantity
        product.update!(stock_quantity: product.stock_quantity - quantity)
      end
    end

    # Clear the cart
    session[:cart] = {}

    # Flash message (Rubric 4.2.3)
    flash[:notice] = "Order placed successfully! Order ##{@order.id}"

    redirect_to confirmation_order_path(@order)
  end

  # Order confirmation page
  def confirmation
    @order = Order.includes(:order_items, :address, :user).find(params[:id])
    @province = @order.address.province
  end

  # Order history for logged-in users (Rubric 3.2.1)
  def index
    if user_signed_in?
      redirect_to account_orders_path
    else
      flash[:alert] = "Please log in to view your orders."
      redirect_to new_user_session_path
    end
  end

  private

  def set_provinces
    @provinces = Province.all.order(:name)
  end
end