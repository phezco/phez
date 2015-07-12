class AddModerations < ActiveRecord::Migration
  def change
    create_table :moderations do |t|
      t.integer :user_id, null: false
      t.integer :subphez_id, null: false

      t.timestamps null: false
    end
  end
end
