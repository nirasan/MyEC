class Order < ActiveRecord::Base
  belongs_to :user
  has_many :order_items

  validates :name, :presence => true
  validates :address, :presence => true
  validates :zip_code, :presence => true, :format => { with: /\A\d{3}\-?\d{4}\z/ }
  validates :phone_number, :presence => true, :format => { with: /\A\d{2,4}\-?\d{2,4}\-?\d{4}\z/ }
  validates :price, :presence => true
  validates :cash_on_delivery_price, :presence => true
  validates :postage_price, :presence => true
  validates :tax_price, :presence => true
  validates :total_price, :presence => true
  validates :delivery_date, :presence => true
  validates :delivery_timezone, :presence => true
  validate :delivary_date_is_business_day
  validate :delivary_timezone_is_valid

  after_create :create_order_items
  after_update :confirmed

  def self.new_by_user(user, last_postal_data)
    order = Order.new(
      user: user,
      name: user.name || last_postal_data.try(:fetch, :name.to_s, ''),
      address: user.address || last_postal_data.try(:fetch, :address.to_s, ''),
      zip_code: user.zip_code || last_postal_data.try(:fetch, :zip_code.to_s, ''),
      phone_number: user.phone_number || last_postal_data.try(:fetch, :phone_number.to_s, '')
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

  def self.get_deliverable_dates(today = Date.today)
    (0..30).map{|i| today + i.day }.select{|d| d.workday? }.slice(3, 12)
  end

  def delivary_date_is_business_day
    if !Order.get_deliverable_dates.include?(delivery_date)
      errors.add(:delivery_date, "配送可能な日付ではありません")
    end
  end

  def delivary_timezone_is_valid
    p delivery_timezone
    p Settings.delivery_timezone
    if !Settings.delivery_timezone.include?(delivery_timezone)
      errors.add(:delivery_timezone, "配送可能な時間帯ではありません")
    end
  end
end
