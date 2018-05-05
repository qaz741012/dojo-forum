class User < ApplicationRecord
  # validates :name, presence: true

  mount_uploader :avatar, AvatarUploader

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts, dependent: :destroy

  has_many :collects, dependent: :destroy
  has_many :collected_posts, through: :collects, source: :post

  has_many :replies, dependent: :destroy
  has_many :replied_posts, through: :replies, source: :post

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy
  has_many :request_friends, through: :inverse_friendships, source: :user

  def admin?
    self.role == "admin"
  end

  def collected_post?(post)
    self.collected_posts.include?(post)
  end

  def friend_status(friend)
    if self.friends.include?(friend)
      if self.friendships.find_by_friend_id(friend.id).status == "confirm"
        return "confirm"
      elsif self.friendships.find_by_friend_id(friend.id).status == "request"
        return "request"
      end
    else
      return "unconfirm"
    end
  end

end
