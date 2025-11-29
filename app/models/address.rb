class Address < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :province

  # Validations
  validates :street_address, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
  validates :address_type, presence: true, inclusion: { in: %w[shipping billing] }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    ["address_type", "city", "created_at", "id", "postal_code", "province_id", "street_address", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["province", "user"]
  end
end