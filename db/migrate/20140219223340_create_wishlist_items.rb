class CreateWishlistItems < ActiveRecord::Migration
  def change
    create_table :wishlist_items do |t|
      t.integer :wishlist_id, null: false
      t.integer :item_id, null: false

      t.timestamps
    end

    add_index :wishlist_items, :wishlist_id
    add_index :wishlist_items, :item_id
    add_index :wishlist_items, [:wishlist_id, :item_id], unique: true
  end
end
