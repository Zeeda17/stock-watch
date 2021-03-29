require 'json'
require 'httparty'

class StocksController < ApplicationController
  include HTTParty
  include StocksHelper
  before_action :set_stock, only: %i[ show edit update destroy ]

  # GET /stocks or /stocks.json
  def index
    @stock = Stock.all
    
    if !params[:stock].nil?
      @stock = Stock.new(stock_params)  
    end
    

    # @stockInfo = getStockAutoComplete(@search_input, @region_input, @range_input)
  end

  # GET /stocks/1 or /stocks/1.json
  def show
    @stock = Stock.find(params[:id])
    @stock_prices = @stock.stock_prices
    # binding.pry


  end

  # GET /stocks/new
  def new
    @stock = Stock.new(stock_params)
  end

  # GET /stocks/1/edit
  def edit
  end

  # POST /stocks or /stocks.json
  def create    
    @stock = Stock.new(stock_params)
    
    # check if stock is in DB already
    foundStock = Stock.find_by(symbol: params[:symbol].upcase)


    if !foundStock.nil?
      redirect_to foundStock
    else
      apiReturn = getStockAutoComplete(params[:symbol], params[:region], params[:range])

      #dont run this if we didn't do an API call
      if (apiReturn)
        saveReturnedStockData(apiReturn) # rename this. currently only formats data
      end

      respond_to do |format|
        # binding.pry
        if @stock.save
          format.html { redirect_to @stock, notice: "Stock was successfully created." }
          format.json { render :show, status: :created, location: @stock }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @stock.errors, status: :unprocessable_entity }
        end
      end

      if (apiReturn)
        i = 0
        
        # binding.pry
        while i < apiReturn['chart']['result'][0]['indicators']['quote'][0]['volume'].size do #
          @stock_price = StockPrice.new
          @stock_price.stock = @stock
          formatReturnedStockPriceData(apiReturn,i)
          @stock_price.save

          # respond_to do |format|
          #   if !@stock_price.save
          #     format.html { render :new, status: :unprocessable_entity }
          #     format.json { render json: @stock.errors, status: :unprocessable_entity }
          #   end
          # end
          i+=1
        end
      end
    end
    

  end

  # PATCH/PUT /stocks/1 or /stocks/1.json
  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to @stock, notice: "Stock was successfully updated." }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1 or /stocks/1.json
  def destroy
    @stock.destroy
    respond_to do |format|
      format.html { redirect_to stocks_url, notice: "Stock was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      # binding.pry
      @stock = Stock.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def stock_params
      # binding.pry
      params.permit(:symbol)
      # params.require(:stock).permit(:name)
    end

    def search_params
      params.permit(:symbol, :region, :range)
      # binding.pry
    end
end
