class RemoveCheckedOutFromCarts < ActiveRecord::Migration
  def up
    remove_column :carts, :checked_out
  end

  def down
    add_column :carts, :checked_out, default: false
  end
end
