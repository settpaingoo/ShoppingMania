class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.integer :cart_id, null: false
      t.integer :item_id, null: false
      t.integer :quantity, null: false

      t.timestamps
    end

    add_index :cart_items, :cart_id
    add_index :cart_items, :quantity
  end
end
