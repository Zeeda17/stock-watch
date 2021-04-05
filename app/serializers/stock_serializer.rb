class StockSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :symbol, :exchangeName, :currency, :instrumentType, :firstTradeDate, :regularMarketTime, :gmtoffset, :timezone, :exchangeTimezoneName, :regularMarketPrice, :chartPreviousClose

  has_many :stock_prices
end
