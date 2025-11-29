class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true
  validates :last_name, presence: true

  # Ransackable attributes for ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "first_name", "id", "last_name", "updated_at", "username"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["addresses", "orders"]
  end

  # Full name helper
  def full_name
    "#{first_name} #{last_name}"
  end
end