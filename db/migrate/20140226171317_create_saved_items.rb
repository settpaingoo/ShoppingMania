class CreateSavedItems < ActiveRecord::Migration
  def change
    create_table :saved_items do |t|
      t.integer :cart_id, null: false
      t.integer :item_id, null: false

      t.timestamps
    end

    add_index :saved_items, :cart_id
    add_index :saved_items, :item_id
    add_index :saved_items, [:cart_id, :item_id], unique: true
  end
end
