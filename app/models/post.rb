class Post < ApplicationRecord
  mount_uploader :photo, PhotoUploader

  scope :public_posts, -> { where(auth: "public") }
  scope :self_posts, -> (user) { where(auth: "self", user_id: user.id) }
  scope :friend_posts, -> (user) {where(auth: "friend", user_id: (user.friendships.where(status: "confirm").pluck(:friend_id) << user.id))}
  scope :auth_posts, -> (user) { public_posts.or(self_posts(user)).or(friend_posts(user)) }

  validates :title, :content, :user_id, presence: true

  belongs_to :user

  has_many :replies, dependent: :destroy
  has_many :replied_users, through: :replies, source: :user

  has_many :post_categories, dependent: :destroy
  has_many :categories, through: :post_categories

end
