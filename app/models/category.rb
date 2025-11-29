class Category < ApplicationRecord
  # Associations
  has_many :product_categories, dependent: :destroy
  has_many :products, through: :product_categories

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
end