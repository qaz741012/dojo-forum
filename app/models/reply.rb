class Reply < ApplicationRecord
  # validates :comment, :user_id, :post_id, presence: true

  belongs_to :user
  belongs_to :post, counter_cache: :replies_count
end
