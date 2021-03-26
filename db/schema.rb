# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_26_173304) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "stock_prices", force: :cascade do |t|
    t.string "symbol"
    t.string "exchangeName"
    t.string "date"
    t.string "open"
    t.string "close"
    t.string "high"
    t.string "low"
    t.string "volume"
    t.bigint "stock_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stock_id"], name: "index_stock_prices_on_stock_id"
    t.index ["symbol", "exchangeName", "date"], name: "index_stock_prices_on_symbol_and_exchangeName_and_date", unique: true
  end

  create_table "stocks", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "currency"
    t.string "symbol"
    t.string "exchangeName"
    t.string "instrumentType"
    t.integer "firstTradeDate"
    t.integer "regularMarketTime"
    t.integer "gmtoffset"
    t.string "timezone"
    t.string "exchangeTimezoneName"
    t.float "regularMarketPrice"
    t.float "chartPreviousClose"
    t.index ["symbol", "exchangeName"], name: "index_stocks_on_symbol_and_exchangeName", unique: true
  end

end
