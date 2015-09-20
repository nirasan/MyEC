class Order < ActiveRecord::Base
  belongs_to :user
  has_many :order_items

  validates :name, :presence => true
  validates :address, :presence => true
  validates :zip_code, :presence => true
  validates :phone_number, :presence => true
  validates :price, :presence => true

  after_create :create_order_items
  after_update :confirmed

  def self.new_by_user(user)
    Order.new(
      name: user.name,
      address: user.address,
      zip_code: user.zip_code,
      phone_number: user.phone_number
      #TODO: price
    )
  end

  def create_order_items
    user.carts.each do |cart|
      self.order_items.create(user: user, item: cart.item, amount: cart.amount)
    end
  end

  def confirmed
    if self.confirmed_flag_changed? && self.confirmed_flag
      user.carts.each do |cart|
        cart.destroy
      end
    end
  end
end
