class FixWrongIndexOfCartItems < ActiveRecord::Migration
  def up
    remove_index :cart_items, :quantity
    add_index :cart_items, :item_id
  end

  def down
    add_index :cart_items, :quantity
    remove_index :cart_items, :item_id
  end
end
