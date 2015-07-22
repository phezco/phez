class PhezBitcoin

  def self.btc_in_usd
    ticker_endpoint = "https://www.bitstamp.net/api/ticker/"
    ticker_json = RestClient.get(ticker_endpoint)
    json = ActiveSupport::JSON.decode(ticker_json)
    json['last'].to_f
  end

  # Usage: btc_balance, mbtc_balance = *PhezBitcoin.balance
  def self.balance
    api_endpoint = "https://bitcoin.toshi.io/api/v0/addresses/#{Figaro.env.bitcoin_address}"
    balance_json = RestClient.get(api_endpoint)
    json = ActiveSupport::JSON.decode(balance_json)
    @satoshi_balance = json['balance']
    btc_balance = (@satoshi_balance.to_f / 100000000.0).round(5)
    mbtc_balance = (@satoshi_balance.to_f / 100000.0).round(0)
    [btc_balance, mbtc_balance]
  end

end