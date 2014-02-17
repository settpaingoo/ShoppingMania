class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.integer :user_id
      t.boolean :checked_out, default: false

      t.timestamps
    end

    add_index :carts, :user_id
  end
end
