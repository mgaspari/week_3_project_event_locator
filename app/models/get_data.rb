require 'pry'
require 'json'
require 'rest-client'
class DataGet

  attr_accessor :link, :request

  def initialize(city)
    inputCity = city
    startDate = "2017-08-23T00:00:00Z"
    @link = "https://app.ticketmaster.com/discovery/v2/events.json?countryCode=US&city=#{inputCity}&startDateTime=#{startDate}&apikey=vZJkJkrliPbqA8RP1qsXrYlAg6YSns8m"
    @request = JSON.parse(RestClient.get(self.link))
    "k"
  end

  def return_events_under_max(user_max)
    @request["_embedded"]["events"].select do |event|
     event["priceRanges"][0]["max"] < user_max
    end
  end
end

binding.pry

"k"
