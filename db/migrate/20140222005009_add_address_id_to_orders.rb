class AddAddressIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :address_id, :integer, null: false
    add_index :orders, :address_id
  end
end
