class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates :title, presence: true
  validates :body, presence: true
  validate :at_least_one_tag
  def at_least_one_tag
    errors.add(:tags, "must have at least one tag") if tags.empty?
  end

end
