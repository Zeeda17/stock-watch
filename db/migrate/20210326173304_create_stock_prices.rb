class CreateStockPrices < ActiveRecord::Migration[6.1]
  def change
    create_table :stock_prices do |t|
      t.string :symbol
      t.string :exchangeName
      t.integer :date
      t.real :open
      t.real :close
      t.real :high
      t.real :low
      t.integer :volume

      t.belongs_to :stock

      t.timestamps
    end
    add_index :stock_prices, [:symbol, :exchangeName, :date], unique: true
  end
end
