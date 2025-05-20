class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Optional: make image optional
  validates :image, presence: false

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
end