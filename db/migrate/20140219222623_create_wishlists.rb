class CreateWishlists < ActiveRecord::Migration
  def change
    create_table :wishlists do |t|
      t.integer :user_id, null: false
      t.string :name, null: false

      t.timestamps
    end

    add_index :wishlists, :user_id
  end
end
