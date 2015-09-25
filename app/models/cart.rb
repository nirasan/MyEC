class Cart < ActiveRecord::Base
  belongs_to :user
  belongs_to :item

  validates :amount, presence: true, numericality: {greater_than: 0}
end
