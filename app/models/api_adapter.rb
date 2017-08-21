class ApiAdapter
  attr_accessor :link
  CHARACTERS = []

  def initialize(link = 'http://www.swapi.co/api/people/')
    @link = link
    self.page_loop
  end

  def link_valid?
    !self.link.nil?
  end

  def request
    @request = JSON.parse(RestClient.get(self.link))
  end

  def page_loop
    while self.link_valid?
      CHARACTERS << self.request['results']
      self.link = request["next"]
      puts self.link
    end
  end

  def character_array
    CHARACTERS.flatten
  end

end
