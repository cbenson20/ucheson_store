class Product < ApplicationRecord
  # Associations
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories

  # Validations
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Scopes for filtering (Rubric 2.4)
  scope :on_sale, -> { where(on_sale: true) }
  scope :new_arrivals, -> { where("created_at >= ?", 3.days.ago) }
  scope :recently_updated, -> { where("updated_at >= ? AND created_at < ?", 3.days.ago, 3.days.ago) }

  # Ransack configuration for ActiveAdmin search
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "name", "new_arrival", "on_sale", "price", "stock_quantity", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["categories", "product_categories"]
  end
end