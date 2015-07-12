class AddDeletedComments < ActiveRecord::Migration
  def change
    add_column :comments, :is_deleted, :boolean, default: false
  end
end
