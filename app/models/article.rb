class Article < ApplicationRecord
  PICTURE_LINK_REGEX = /(https?:\/\/.*\.(?:png|jpg))/i

  belongs_to :user

  validates :title, :body, :user, presence: true 

  validates :title,   length: { minimum: 10, maximum: 255 }
  validates :body,    length: { minimum: 500, maximum: 2000 }
  validates :picture, format: { with: PICTURE_LINK_REGEX, message: 'Please write the link!' }
end
