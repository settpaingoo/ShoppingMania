class AddUniqueConstraintToCartItems < ActiveRecord::Migration
  def change
    add_index :cart_items, [:cart_id, :item_id], unique: true
  end
end
