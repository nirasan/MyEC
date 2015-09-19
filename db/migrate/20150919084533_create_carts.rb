class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.references :user, index: true, foreign_key: true
      t.references :item, index: true, foreign_key: true
      t.integer :amount

      t.timestamps null: false
    end
  end
end
