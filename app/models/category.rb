class Category < ApplicationRecord
  # Associations
  has_many :product_categories, dependent: :destroy
  has_many :products, through: :product_categories

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "name", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["products", "product_categories"]
  end
end