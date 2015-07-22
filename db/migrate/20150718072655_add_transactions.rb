class AddTransactions < ActiveRecord::Migration
  def change

    create_table :transactions do |t|
      t.integer :user_id
      t.float :amount_mbtc
      t.string :txn_type
      t.timestamps
    end

  end
end
