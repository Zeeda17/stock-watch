require 'httparty'
require 'rubygems'

module StocksHelper
  include HTTParty

  # API call
  def getStockAutoComplete(symbol_input, region_input, range_input)
    key = Rails.application.credentials.rapidAPI[:key]
    host = Rails.application.credentials.rapidAPI[:host]
# binding.pry
    regions = {
      :valid => ['US','BR','AU','CA','FR','DE','HK','IN','IT','ES','GB','SG'],
      :default => 'US'
    }
    intervals = {
      :valid => ['1m','2m','5m','15m','60m','1d'], # Valid for API but this app is not build to support these currently
      :default => '1d'
    }
    ranges = {
      :valid => ['1d','5d','1mo','3mo','6mo','1y','2y','5y','10y','ytd','max'],
      :default => '5d'
    }

    self.class.base_uri "https://" + host
    binding.pry
    if (validateStockInput(symbol_input))
      symbol_input.gsub!(/\W+/, '')
    end
    
    if (!validateStockInput(symbol_input))
      # no need to continue
      return false
    end

    region_input = formatInputForAPI(region_input, regions)
    range_input = formatInputForAPI(range_input, ranges)
    # interval = formatInputForAPI(interval, intervals) # add this if the code gets updating to handle this choice
    
    headers = {
      # replace nil with key here to allow the API to work
      # this is a stopgap to limit my api hits
      "x-rapidapi-key" => key, 
      "x-rapidapi-host" => host
    }
    body = {
      "interval" => intervals[:default],
      "symbol" => symbol_input,
      "region" => region_input,
      "range" => range_input
    }

    #takes base_uri and concats first param to it for API endpoint
    self.class.get(
      '/stock/v2/get-chart',
      :query => body,
      :headers => headers)
  end

  # takes api data and puts into @stock.
  # Returns nil if all good
  # Returns api error if there was an error
  def saveReturnedStockData(apiReturn)
    apiReturn = apiReturn['chart']
    # binding.pry
    if !apiReturn['error'].nil?
      # we need to spit out error
      return apiReturn['error']
    end

    @stock.name = apiReturn['result'][0]['meta']['symbol']
    @stock.currency = apiReturn['result'][0]['meta']['currency']
    @stock.symbol = apiReturn['result'][0]['meta']['symbol']
    @stock.exchangeName = apiReturn['result'][0]['meta']['exchangeName']
    @stock.instrumentType = apiReturn['result'][0]['meta']['instrumentType']
    @stock.firstTradeDate = apiReturn['result'][0]['meta']['firstTradeDate']
    @stock.regularMarketTime = apiReturn['result'][0]['meta']['regularMarketTime']
    @stock.gmtoffset = apiReturn['result'][0]['meta']['gmtoffset']
    @stock.timezone = apiReturn['result'][0]['meta']['timezone']
    @stock.exchangeTimezoneName = apiReturn['result'][0]['meta']['exchangeTimezoneName']
    @stock.regularMarketPrice = apiReturn['result'][0]['meta']['regularMarketPrice']
    @stock.chartPreviousClose = apiReturn['result'][0]['meta']['chartPreviousClose']

    # binding.pry
  end

  # takes api data and puts into @stock_price.
  # Returns nil if all good
  # Returns api error if there was an error
  def formatReturnedStockPriceData(apiReturn, i)
    apiReturn = apiReturn['chart']
    interval = apiReturn['result'][0]['meta']['dataGranularity'] # not used currently
    range = apiReturn['result'][0]['meta']['range']

    if !apiReturn['error'].nil?
      # we need to spit out error
      return apiReturn['error']
    end
    # binding.pry
    # StockPrice.find_by(Stock.find_by(@stock))

    @stock_price.symbol = @stock.symbol
    @stock_price.exchangeName = @stock.exchangeName
    @stock_price.stock = @stock
    @stock_price.date = apiReturn['result'][0]['timestamp'][i]
    @stock_price.open = apiReturn['result'][0]['indicators']['quote'][0]['open'][i]
    @stock_price.close = apiReturn['result'][0]['indicators']['quote'][0]['close'][i]
    @stock_price.high = apiReturn['result'][0]['indicators']['quote'][0]['high'][i]
    @stock_price.low = apiReturn['result'][0]['indicators']['quote'][0]['low'][i]
    @stock_price.volume = apiReturn['result'][0]['indicators']['quote'][0]['volume'][i]
    
  end

  def formatInputForAPI(input, allowed_values)
    if (validateStockInput(input))
      input.gsub!(/\W+/, '')
    end

    if (!validateStockInput(input) || (!allowed_values[:valid].include? input.upcase))
      input = allowed_values[:default]
    end
  end

  # is data good?
  def validateStockInput(input)
    if (input.nil? || input == '')
      return false
    end

    return true
  end
end
