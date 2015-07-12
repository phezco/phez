class AddMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id, null: false
      t.integer :from_user_id
      t.string :title
      t.text :body
      t.timestamps null: false
    end

    add_column :users, :orange, :boolean, :default => false
  end
end
