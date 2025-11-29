class Province < ApplicationRecord
  # Associations
  has_many :addresses

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true, length: { is: 2 }
  validates :gst_rate, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :pst_rate, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :hst_rate, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Method to calculate total tax rate
  def total_tax_rate
    (gst_rate || 0) + (pst_rate || 0) + (hst_rate || 0)
  end
end