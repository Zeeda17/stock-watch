class CreateStockSymbols < ActiveRecord::Migration[6.1]
  def change
    create_table :stock_symbols do |t|
      t.string :region
      t.string :range

      t.timestamps
    end
  end
end
