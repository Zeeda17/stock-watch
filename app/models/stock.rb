class Stock < ApplicationRecord
  has_many :stock_prices

  validates :symbol, presence: true
end
