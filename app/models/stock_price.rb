class StockPrice < ApplicationRecord
  belongs_to :stock
  
  #validates :stock_id
end
