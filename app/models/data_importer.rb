class DataImporter
  attr_accessor :data

  def initialize
    self.data = ApiAdapter.new
  end

  def save_character(character_hash)
    #save character data with ActiveRecord
    Character.create(
      name: character_hash["name"],
      height: character_hash["height"],
      mass: character_hash["mass"],
      hair_color: character_hash["hair_color"],
      skin_color: character_hash["skin_color"],
      eye_color: character_hash["eye_color"],
      birth_year: character_hash["birth_year"],
      gender: character_hash["gender"])
  end

  def save_movie(movie_hash, character_instance)
    #save movie should create movie instance and association with character
    #jarjar.appearances.create(movie: Movie.find_or_create_by(title: 'new hoops'))
    movie =  Movie.find_by(episode_id: movie_hash[:episode_id])
    unless movie
      movie = Movie.create(movie_hash)
    end
    character_instance.appearances.create(movie: movie)
  end

  def movie_link_to_hash(movie_link)
    request = JSON.parse(RestClient.get(movie_link))
    {
      title: request["title"],
      episode_id: request["episode_id"],
      opening_crawl: request["opening_crawl"],
      director: request["director"],
      producer: request["producer"],
      release_date: request["release_date"]
    }
  end

  def data_import
    self.data.character_array.each do |character_hash|
      character_instance = save_character(character_hash)
      character_hash["films"].each do |movie_link|
        save_movie(movie_link_to_hash(movie_link), character_instance)
      end
    end
  end

  #jarjar.appearances.create(movie: Movie.find_or_create_by(title: 'new hoops'))
end
