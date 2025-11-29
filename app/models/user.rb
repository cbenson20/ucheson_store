class User < ApplicationRecord
  # Associations
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_one :cart, dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  # Helper method for full name
  def full_name
    "#{first_name} #{last_name}"
  end

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "first_name", "id", "last_name", "updated_at", "username"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["addresses", "cart", "orders"]
  end
end