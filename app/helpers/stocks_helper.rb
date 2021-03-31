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
      :valid => ['us','br','au','ca','fr','de','hk','in','it','es','gb','sg'],
      :default => 'us'
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
# binding.pry
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
      "interval" => intervals[:default].downcase, # case matters
      "symbol" => symbol_input.upcase,
      "region" => region_input.upcase,
      "range" => range_input.downcase # case matters
    }
# binding.pry
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

    @stock.name = apiReturn['result'][0]['meta']['symbol'].upcase
    @stock.currency = apiReturn['result'][0]['meta']['currency'].upcase
    @stock.symbol = apiReturn['result'][0]['meta']['symbol'].upcase
    @stock.exchangeName = apiReturn['result'][0]['meta']['exchangeName'].upcase
    @stock.instrumentType = apiReturn['result'][0]['meta']['instrumentType'].upcase
    @stock.firstTradeDate = apiReturn['result'][0]['meta']['firstTradeDate']
    @stock.regularMarketTime = apiReturn['result'][0]['meta']['regularMarketTime']
    @stock.gmtoffset = apiReturn['result'][0]['meta']['gmtoffset']
    @stock.timezone = apiReturn['result'][0]['meta']['timezone'].upcase
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

    @stock_price.symbol = @stock.symbol.upcase
    @stock_price.exchangeName = @stock.exchangeName.upcase
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

    if (!validateStockInput(input) || (!allowed_values[:valid].include? input.downcase))
      input = allowed_values[:default]
    end

    return input
  end

  # is data good?
  def validateStockInput(input)
    if (input.nil? || input == '')
      return false
    end

    return true
  end
end
