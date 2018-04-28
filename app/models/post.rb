class Post < ApplicationRecord
  validates :title, :content, :draft?, :user_id, presence: true

  has_many :replies, dependent: :destroy
  has_many :replied_users, through: :replies, source: :user

  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories
end
