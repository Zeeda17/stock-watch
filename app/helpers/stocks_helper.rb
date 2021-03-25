require 'httparty'
require 'rubygems'

module StocksHelper
  include HTTParty

  def getAutoComplete
    key = Rails.application.credentials.rapidAPI[:key]
    host = Rails.application.credentials.rapidAPI[:host]
    self.class.base_uri "https://" + host
    
    headers = {
      # replace nil with key here to allow the API to work
      # this is a stopgap to limit my api hits
      "x-rapidapi-key" => nil, #key, 
      "x-rapidapi-host" => host
    }
    body = { 
      "q" => "tesla",
      "region" => "US"
    }

    #takes base_uri and concats first param to it for API endpoint
    self.class.get(
      '/auto-complete',
      :query => body,
      :headers => headers)
  end
end
