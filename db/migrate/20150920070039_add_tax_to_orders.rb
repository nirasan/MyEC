class AddTaxToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :tax_price, :decimal
    add_column :orders, :cash_on_delivery_price, :decimal
    add_column :orders, :postage_price, :decimal
    add_column :orders, :total_price, :decimal
    add_column :orders, :delivery_date, :date
    add_column :orders, :delivery_timezone, :string
  end
end
