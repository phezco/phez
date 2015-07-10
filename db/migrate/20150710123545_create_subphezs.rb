class CreateSubphezs < ActiveRecord::Migration
  def change
    create_table :subphezes do |t|
      t.integer :user_id, null: false
      t.string :path, null: false
      t.string :title, null: false
      t.text :sidebar

      t.timestamps null: false
    end
  end
end
