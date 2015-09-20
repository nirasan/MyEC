class Order < ActiveRecord::Base
  belongs_to :user
  has_many :order_items

  validates :name, :presence => true
  validates :address, :presence => true
  validates :zip_code, :presence => true
  validates :phone_number, :presence => true
  validates :price, :presence => true
  validates :cash_on_delivery_price, :presence => true
  validates :postage_price, :presence => true
  validates :tax_price, :presence => true
  validates :total_price, :presence => true

  after_create :create_order_items
  after_update :confirmed

  def self.new_by_user(user)
    order = Order.new(
      user: user,
      name: user.name,
      address: user.address,
      zip_code: user.zip_code,
      phone_number: user.phone_number
    )
    order.set_prices
    return order
  end

  def set_prices
    sum_amount = 0
    price = 0
    user.carts.each do |cart|
      sum_amount = sum_amount + cart.amount
      price = price + (cart.amount * cart.item.price)
    end
    self.price = price
    self.calc_cash_on_delivery_price
    self.calc_postage_price(sum_amount)
    self.calc_tax_price
    self.calc_total_price
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

  def calc_cash_on_delivery_price
    Settings.cash_on_delivery.each do |ary|
      threshold, price = ary[0], ary[1]
      if self.price >= threshold
        self.cash_on_delivery_price = price
      end
    end
  end

  def calc_postage_price(amount)
    unit = amount / Settings.postage.amount
    unit = unit + 1 if amount % Settings.postage.amount > 0
    self.postage_price = unit * Settings.postage.price
  end

  def calc_tax_price
    self.tax_price = (price + cash_on_delivery_price + postage_price) * Settings.tax.to_f / 100
  end

  def calc_total_price
    self.total_price = (price + cash_on_delivery_price + postage_price + tax_price).floor
  end
end
