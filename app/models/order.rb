class Order < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :address
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  # Validations
  validates :status, presence: true, inclusion: { in: %w[pending paid shipped delivered cancelled] }
  validates :subtotal, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :tax_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Scopes
  scope :pending, -> { where(status: "pending") }
  scope :paid, -> { where(status: "paid") }
  scope :shipped, -> { where(status: "shipped") }

  # Calculate totals from order items
  def calculate_totals(province)
    self.subtotal = order_items.sum { |item| item.price_at_purchase * item.quantity }
    self.tax_amount = subtotal * province.total_tax_rate
    self.total = subtotal + tax_amount
  end
end