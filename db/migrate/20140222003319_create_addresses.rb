class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zipcode, null: false
      t.integer :user_id

      t.timestamps
    end

    add_index :addresses, :user_id
  end
end
