class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name
      t.text :address
      t.string :zip_code
      t.string :phone_number
      t.decimal :price
      t.boolean :confirmed_flag

      t.timestamps null: false
    end
  end
end
