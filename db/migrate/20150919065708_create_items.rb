class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.decimal :price
      t.text :description
      t.boolean :show_flag
      t.integer :show_priority

      t.timestamps null: false
    end
  end
end
