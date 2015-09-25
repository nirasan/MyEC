class Item < ActiveRecord::Base
  has_many :carts
  has_many :order_items
  mount_uploader :image, ImageUploader

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: {greater_than: 0}
  validates :show_priority, presence: true, numericality: true

  scope :visible, -> { where(show_flag: true) }
  scope :order_by_priority, -> { order('show_priority DESC') }
end
