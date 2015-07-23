class AddBitcoinAddressToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :bitcoin_address, :string
  end
end
