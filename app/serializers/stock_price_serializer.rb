class StockPriceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :symbol, :exchangeName, :date, :open, :close, :high, :low, :volume, :stock_id 
end
