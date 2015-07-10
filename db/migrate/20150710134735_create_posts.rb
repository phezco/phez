class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id, null: false
      t.integer :subphez_id, null: false
      t.string :guid, null: false
      t.string :url
      t.string :title, null: false
      t.integer :vote_total, null: false, default: 0
      t.boolean :is_self, null: false, default: false
      t.text :body

      t.timestamps null: false
    end
  end
end
