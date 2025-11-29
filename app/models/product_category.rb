class ProductCategory < ApplicationRecord
  # Associations
  belongs_to :product
  belongs_to :category

  # Validations
  validates :product_id, uniqueness: { scope: :category_id, message: "already assigned to this category" }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    ["category_id", "created_at", "id", "product_id", "updated_at"]
  end
end