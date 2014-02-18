class AddUserIdIndexToTokens < ActiveRecord::Migration
  def change
    add_index :tokens, :user_id
  end
end
