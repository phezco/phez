class AddMessageReason < ActiveRecord::Migration
  def change
    add_column :messages, :reason, :string
  end
end
