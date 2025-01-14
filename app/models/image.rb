class Image < ApplicationRecord
  belongs_to :item, optional: true
  validates :image, presence: {message: "画像がありません"}
  mount_uploader :image, ImageUploader
end
