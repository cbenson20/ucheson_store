class Address < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :province

  # Validations
  validates :street_address, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
  validates :address_type, presence: true, inclusion: { in: %w[shipping billing] }
end