require 'httparty'
require 'rubygems'

module StocksHelper
  include HTTParty

  def getStockAutoComplete(search_input, region_input)
    key = Rails.application.credentials.rapidAPI[:key]
    host = Rails.application.credentials.rapidAPI[:host]
    valid_regions = ['US','BR','AU','CA','FR','DE','HK','IN','IT','ES','GB','SG']
    default_region = 'US'
    self.class.base_uri "https://" + host

    if (validateStockInput(search_input))
      search_input.gsub!(/[^a-zA-Z]/, '')
    end
    
    if (!validateStockInput(search_input))
      # no need to continue
      return
    end

    if (validateStockInput(region_input))
      region_input.gsub!(/[^a-zA-Z]/, '')
    end

    if (!validateStockInput(region_input) || (!valid_regions.include? region_input.upcase))
      region_input = default_region
    end
    
    headers = {
      # replace nil with key here to allow the API to work
      # this is a stopgap to limit my api hits
      "x-rapidapi-key" => nil, #key, 
      "x-rapidapi-host" => host
    }
    body = { 
      "q" => search_input,
      "region" => region_input
    }

    #takes base_uri and concats first param to it for API endpoint
    self.class.get(
      '/auto-complete',
      :query => body,
      :headers => headers)
  end

  # is data good?
  def validateStockInput(input)
    if (input.nil? || input == '')
      return false
    end

    return true
  end
end
