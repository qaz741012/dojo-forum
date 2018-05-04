class Collect < ApplicationRecord
  validates :post_id, uniqueness: { scope: :user_id }
  validates :user_id, :post_id, presence: true

  belongs_to :user
  belongs_to :post
end
