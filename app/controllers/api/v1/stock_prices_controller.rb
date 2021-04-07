module Api
  module V1
    class StockPricesController < ApplicationController
      def index
        stocks = Stock.all

        render json: StockSerializer.new(stocks, options).serialized_json
      end

      def show
        stock = Stock.find_by(symbol: params[:symbol])

        render json: StockSerializer.new(stock, options).serialized_json
      end

      def create
        stock = Stock.new(stock_params)

        if stock.save
          render json: StockSerializer.new(stock).serialized_json
        else
          render json: { error: stock.errors.messages }, status: 422
        end
      end

      def update #what happens if a ticker gets updated?
        stock = Stock.find_by(symbol: params[:symbol])

        if stock.update(stock_params)
          render json: StockSerializer.new(stock, options).serialized_json
        else
          render json: { error: stock.errors.messages }, status: 422
        end
      end

      def destroy #ticker got delisted? How would I know?
        stock = Stock.find_by(symbol: params[:symbol])

        if stock.destroy
          head :no_content
        else
          render json: { error: stock.errors.messages }, status: 422
        end
      end

      private

      def stock_params
        params.require(:stock).permit()#everything
      end
      
      def options
        @options ||= { include: %i[stock_prices]}
      end
    end
  end  
end