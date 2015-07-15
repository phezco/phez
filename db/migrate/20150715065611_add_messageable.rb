class AddMessageable < ActiveRecord::Migration
  def change
    add_column :messages, :messageable_id, :integer
    add_column :messages, :messageable_type, :string
  end
end
