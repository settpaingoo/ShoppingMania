class AddUniqueConstraintToOrderItems < ActiveRecord::Migration
  def change
    add_index :order_items, [:order_id, :item_id], unique: true
  end
end
