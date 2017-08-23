require 'pry'
require 'json'
require 'rest-client'
class DataGet

  attr_accessor :link, :request, :price, :selected_events, :final_data

  def initialize(city, date, price)
    inputCity = city
    startDate = "#{date}T00:00:00Z" #"2017-08-23T00:00:00Z"
    @price = price
    @link = "https://app.ticketmaster.com/discovery/v2/events.json?countryCode=US&city=#{inputCity}&startDateTime=#{startDate}&apikey=vZJkJkrliPbqA8RP1qsXrYlAg6YSns8m"
    @request = JSON.parse(RestClient.get(self.link))
    self.return_events_under_max
    self.get_event_info
  end

  def get_event_info
    @final_data = @selected_events.collect do |event|
      eventName = event["name"]
      eventUrl = event["url"]
      eventPrice = "Min - #{event["priceRanges"][0]["min"]} Max - #{event["priceRanges"][0]["max"]}"
      [eventName, eventUrl, eventPrice]
    end
  end
#we changed this so that it doesn't take in a value
  def return_events_under_max
    @selected_events =  @request["_embedded"]["events"].select do |event|

      event["priceRanges"] && event["priceRanges"][0]["min"] < @price
    #  event["priceRanges"][0]["max"] < user_max
     #puts event["priceRanges"]
    end
    self.get_event_info
  end


end
