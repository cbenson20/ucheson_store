class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_cart, :cart_item_count

  # Get or initialize the cart from session (Rubric 3.1.1, 4.2.3)
  def current_cart
    session[:cart] ||= {}
  end

  # Count total items in cart (for header badge)
  def cart_item_count
    current_cart.values.sum
  end

  # Add flash message helper
  def add_to_cart_flash(product_name)
    flash[:notice] = "#{product_name} added to cart!"
  end
end