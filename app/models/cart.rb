class Cart < ApplicationRecord
  # Associations
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  # Validations
  # Either user_id or session_id must be present
  validate :user_or_session_present

  # Calculate cart total
  def total
    cart_items.sum { |item| item.product.price * item.quantity }
  end

  private

  def user_or_session_present
    if user_id.blank? && session_id.blank?
      errors.add(:base, "Cart must belong to either a user or a session")
    end
  end
end