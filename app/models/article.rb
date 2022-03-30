class Article < ApplicationRecord
  PICTURE_LINK_REGEX = /(https?:\/\/.*\.(?:png|jpg))/i

  belongs_to :user
  belongs_to :event
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image

  has_rich_text :body

  validates :title, :body, :user, :event, presence: true 

  validates :title,   length: { minimum: 10, maximum: 255 }
  validates :body,    length: { minimum: 500, maximum: 2000 }
end
