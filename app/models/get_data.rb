class Data

  attr_accessor :link, :request

  def initialize
    @link = "https://app.ticketmaster.com/discovery/v2/events.json?countryCode=US&apikey=ICMptHAMURNy82YswWCiPVsIENGeTxRl"
    @request = JSON.parse(RestClient.get(self.link))
  end

  

end
