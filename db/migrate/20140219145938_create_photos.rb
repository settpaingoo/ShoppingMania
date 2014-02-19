class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :item_id, null: false
      t.attachment :image

      t.timestamps
    end

    add_index :photos, :item_id
  end
end
