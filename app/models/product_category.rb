class ProductCategory < ApplicationRecord
  # Associations
  belongs_to :product
  belongs_to :category

  # Validations
  validates :product_id, uniqueness: { scope: :category_id, message: "already assigned to this category" }
end