require 'pry'
require 'json'
require 'rest-client'
class DataGet

  attr_accessor :link, :request

  def initialize
    @link = "https://app.ticketmaster.com/discovery/v2/events.json?countryCode=US&apikey=ICMptHAMURNy82YswWCiPVsIENGeTxRl"
    @request = JSON.parse(RestClient.get(self.link))
    "k"
  end

  def find_match_city(name)
    #new
    @request["_embedded"]["events"].select do |event|
      event["embedded"]["venues"][0]["city"]["name"] == name
    end
  end

  def create_events(arrayEvents)
    # save this for another class
    # arrayEvents.each do |event|
    #
    # end
  end

end

binding.pry

"k"
