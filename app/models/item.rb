class Item < ActiveRecord::Base
  has_many :carts
  mount_uploader :image, ImageUploader
end
