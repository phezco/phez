class AddModRequests < ActiveRecord::Migration
  def change
    create_table :mod_requests do |t|
      t.integer :inviting_user_id, null: false
      t.integer :user_id, null: false
      t.integer :subphez_id, null: false

      t.timestamps null: false
    end
  end
end
