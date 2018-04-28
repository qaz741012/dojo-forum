class Category < ApplicationRecord
  validates :name, presence: true

  has_many :post_categories, dependent: :restrict_with_error
  has_many :posts, through: :post_categories
end
