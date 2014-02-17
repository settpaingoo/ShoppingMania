class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.integer :price, null: false
      t.integer :stock, null: false
      t.integer :brand_id, null: false
      t.integer :category_id, null: false
      t.text :description

      t.timestamps
    end

    add_index :items, :brand_id
    add_index :items, :category_id
  end
end
