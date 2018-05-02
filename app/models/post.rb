class Post < ApplicationRecord
  mount_uploader :photo, PhotoUploader

  validates :title, :content, :user_id, presence: true

  belongs_to :user

  has_many :replies, dependent: :destroy
  has_many :replied_users, through: :replies, source: :user

  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories
end
