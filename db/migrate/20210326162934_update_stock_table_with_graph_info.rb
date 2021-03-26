class UpdateStockTableWithGraphInfo < ActiveRecord::Migration[6.1]
  def change
    add_column :stocks, :currency, :string
    add_column :stocks, :symbol, :string
    add_column :stocks, :exchangeName, :string
    add_column :stocks, :instrumentType, :string
    add_column :stocks, :firstTradeDate, :integer
    add_column :stocks, :regularMarketTime, :integer
    add_column :stocks, :gmtoffset, :integer
    add_column :stocks, :timezone, :string
    add_column :stocks, :exchangeTimezoneName, :string
    add_column :stocks, :regularMarketPrice, :real
    add_column :stocks, :chartPreviousClose, :real

    add_index :stocks, [:symbol, :exchangeName], unique: true
  end
end
