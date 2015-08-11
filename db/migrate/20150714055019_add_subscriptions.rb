class AddSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id, null: false
      t.integer :subphez_id, null: false

      t.datetime :created_at, null: false
    end
  end
end
