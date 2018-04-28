class Post < ApplicationRecord

  has_many :replies, dependent: :destroy
  has_many :replied_users, through: :replies, source: :user
end
