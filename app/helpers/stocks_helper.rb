require 'httparty'
require 'rubygems'

module StocksHelper
  include HTTParty

  def getStockAutoComplete(symbol_input, region_input, range_input)
    key = Rails.application.credentials.rapidAPI[:key]
    host = Rails.application.credentials.rapidAPI[:host]

    regions = {
      :valid => ['US','BR','AU','CA','FR','DE','HK','IN','IT','ES','GB','SG'],
      :default => 'US'
    }
    intervals = {
      :valid => ['1m','2m','5m','15m','60m','1d'], # Valid for API but this app not build to support these currently
      :default => '1d'
    }
    ranges = {
      :valid => ['1d','5d','1mo','3mo','6mo','1y','2y','5y','10y','ytd','max'],
      :default => '5d'
    }

    self.class.base_uri "https://" + host

    if (validateStockInput(symbol_input))
      symbol_input.gsub!(/[^a-zA-Z]/, '')
    end
    
    if (!validateStockInput(symbol_input))
      # no need to continue
      return
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
      "interval" => interval,
      "symbol" => symbol_input,
      "region" => region_input,
      "range" => range_input
    }

    #takes base_uri and concats first param to it for API endpoint
    self.class.get(
      '/auto-complete',
      :query => body,
      :headers => headers)
  end

  def formatInputForAPI(input, allowed_values)
    if (validateStockInput(input))
      input.gsub!(/[^a-zA-Z]/, '')
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
