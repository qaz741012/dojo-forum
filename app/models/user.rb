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

  def admin?
    self.role == "admin"
  end

  def collected_post?(post)
    self.collected_posts.include?(post)
  end

end
