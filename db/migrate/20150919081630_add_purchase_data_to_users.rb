class AddPurchaseDataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :address, :text
    add_column :users, :zip_code, :string
    add_column :users, :phone_number, :string
  end
end
