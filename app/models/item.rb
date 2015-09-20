class Item < ActiveRecord::Base
  has_many :carts
  has_many :order_items
  mount_uploader :image, ImageUploader

  scope :visible, -> { where(show_flag: true) }
  scope :order_by_priority, -> { order('show_priority DESC') }
end
