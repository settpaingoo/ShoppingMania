class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.integer :user_id, null: false
      t.string :token_string, null: false

      t.timestamps
    end

    add_index :tokens, :token_string, unique: true
  end
end
