class ChangeUserIdForCarts < ActiveRecord::Migration
  def up
    change_column :carts, :user_id, :integer, null: false
  end

  def down
    change_column :carts, :user_id, :integer
  end
end
