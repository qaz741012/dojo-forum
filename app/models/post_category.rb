class PostCategory < ApplicationRecord
  validates :category_id, uniqueness: { scope: :post_id }

  belongs_to :post
  belongs_to :category
end
