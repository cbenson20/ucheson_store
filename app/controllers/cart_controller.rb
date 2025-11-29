class CartController < ApplicationController
  # Show cart page
  def show
    @cart_items = []
    @cart_total = 0

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
  end

  # Add product to cart
  def add
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i
    quantity = 1 if quantity < 1

    # Check stock availability
    if product.stock_quantity < quantity
      flash[:alert] = "Sorry, only #{product.stock_quantity} units available in stock."
      redirect_to product_path(product) and return
    end

    # Add to cart or update quantity
    current_cart[product.id.to_s] ||= 0
    new_quantity = current_cart[product.id.to_s] + quantity

    # Check total quantity doesn't exceed stock
    if new_quantity > product.stock_quantity
      flash[:alert] = "Cannot add more. Only #{product.stock_quantity} units available."
      redirect_to product_path(product) and return
    end

    current_cart[product.id.to_s] = new_quantity
    session[:cart] = current_cart

    flash[:notice] = "#{product.name} added to cart! (Quantity: #{quantity})"
    redirect_to cart_path
  end

  # Remove item from cart
  def remove
    product_id = params[:id]
    product = Product.find_by(id: product_id)
    product_name = product ? product.name : "Item"

    current_cart.delete(product_id)
    session[:cart] = current_cart

    flash[:notice] = "#{product_name} removed from cart."
    redirect_to cart_path
  end

  # Update item quantity
  def update_quantity
    product_id = params[:id]
    product = Product.find_by(id: product_id)
    quantity = params[:quantity].to_i

    if quantity <= 0
      # If quantity is 0 or negative, remove item
      current_cart.delete(product_id)
      flash[:notice] = "Item removed from cart."
    elsif product && quantity > product.stock_quantity
      # Check stock availability
      flash[:alert] = "Only #{product.stock_quantity} units available in stock."
    else
      # Update quantity
      current_cart[product_id] = quantity
      flash[:notice] = "Cart updated."
    end

    session[:cart] = current_cart
    redirect_to cart_path
  end

  # Clear entire cart
  def clear
    session[:cart] = {}
    flash[:notice] = "Cart cleared."
    redirect_to cart_path
  end
end