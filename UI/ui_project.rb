require_relative '../config/environment.rb'
require 'twilio-ruby'
require 'twitter'
class InterfaceApp
  attr_accessor :city, :date, :price, :name, :data, :to_search, :min, :max, :testBool, :user_instance, :phoneNumber

  def user_selection
    @testBool = true
    while @testBool == true
    puts "
    A. Make favorite
    B. Show more
    C. New search
    D. View Favorites
    E. Share an event with a friend
    F. Let everyone know you're going to an event
    G. Exit"
    puts "Please type the associated letter for the choices above"
    user_alphabet_answer = gets.chomp.upcase
    if user_alphabet_answer == "A" || user_alphabet_answer == "B" || user_alphabet_answer == "C" || user_alphabet_answer == "D" || user_alphabet_answer == "E" || user_alphabet_answer == "F" || user_alphabet_answer == "G"
      self.selection_switch(user_alphabet_answer)
      @testBool = false
    else
      puts "Please enter a correct letter!"
    end
    end
  end

  def full_send(user_answer)
    account_sid = "ACaecd121efb5062f699ef7eb8d74f7734"
    auth_token = "3a1c87d9e267e27b4e1d59cd033adcc4"
    client = Twilio::REST::Client.new account_sid, auth_token
    client.messages.create(
      from: "+12019034298",
      to: "+1#{@phoneNumber}",
      body: "Hi! Your friend #{@name} wants to share an event in #{@city} on #{@date}. Check it out #{@data[user_answer.to_i - 1][1]}"
      )
      puts "Message sent!"
      self.user_selection
    end

  def create_everything(user_number)
    #take a user instance and create favorite and pass in the created event
    eventHash = {
    name: @data[user_number.to_i - 1][0],
    city: @city,
    date: @date,
    url: @data[user_number.to_i - 1][1],
    price_range: @data[user_number.to_i - 1][2]
    }
    event = Event.create(eventHash)
    @user_instance.favorites.create(event: event)
    #twitter
    puts "#{@data[user_number.to_i - 1][0]} has been added to your favorites!"
  end

  def adding_to_favorites
    puts "Please select the event number that you would like to save as your favorite."
    valid = true
    while valid
      event_selection = gets.chomp
      if event_selection.to_i < data.size - 1 && event_selection.to_i > 0
        create_everything(event_selection)
        valid = false
      end
    end
    self.user_selection
  end

  def view_favorites
    all = Event.all
    all.each do |event|
      puts "#{event.name}"
    end
    self.user_selection
  end

  def send_to_friend
    puts "Which event would you like to share (Please select the number associated with the event.)?"
    answer = gets.chomp
    puts "What is your friend's phone number?"
    @phoneNumber = gets.chomp
    self.full_send(answer)
  end

  def actually_tweet(handle, answer)

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "ZoE0ZImGOtzOXUinzOZiRC6Zd"
      config.consumer_secret     = "mNjRh4VmQ0RnDwccJJ64vJnyuwAlJyz1R7eyX7QAPUy3GZ5NAv"
      config.access_token        = "900371662520111104-sTfrxVrWhzzPD6WsfF1FNmdK2M1jpjH"
      config.access_token_secret = "YwYAoEzRiznCbRhuVfvmILevy0bjEj1Xz3dfKwuyaNg7S"
    end

    client.update("#{handle} is going to #{@data[answer.to_i - 1][0]} in #{city}!")
    puts "Tweet sent!"
  end

  def send_tweet
    puts "Please type in your Twitter handle."
    twitter_handle = gets.chomp
    puts "Which event would you like to Tweet about?"
    event_tweet = gets.chomp
    self.actually_tweet(twitter_handle, event_tweet)
    self.user_selection
  end

  def selection_switch(letter)
    case letter
    when "A"
      self.adding_to_favorites
    when "B"
      @min += 5
      self.present_results(@min, @max)
    when "C"
      @to_search = true
    when "D"
      self.view_favorites
    when "E"
      self.send_to_friend
    when "F"
      self.send_tweet
    when "G"
      puts "Thank you for using Ticketmaster!"
      exit!
    end
  end

  def present_results(min=0, max=4)
    @min = min
    @max = min + 4

    if @max > (@data.size - 1)
      @max = (@data.size - 1)
    end

    # if @max > (@data.size - 1)
    #   @max = (@data.size - 1)
    # end
    r = @min..@max
    # i = min
    puts "Your results are:"
    for i in r
      puts "
      #{i + 1}
      Event: #{@data[i][0]}
      URL: #{@data[i][1]}
      Price: #{@data[i][2]}
      "
    end

    if @max == (@data.size - 1)
      puts "There are no more results."
    end

    self.user_selection
  end



  def user_interface_tm
    @to_search = true
    puts "Welcome to Ticketmaster! Let us help you find local events! What is your name?"
    @name = gets.chomp.titleize
    @user_instance = User.create(name: @name)
    # User.create(name: @name)
    while @to_search == true
    puts "Hi #{@name}, please type in the city where you'd like to look:"
    @city = gets.chomp.titleize
    puts "What date for shows in #{@city}? (Format: yyyy-mm-dd)"
    @date = gets.chomp
    puts "Awesome! Around how much are you looking to spend?"
    @price = gets.chomp.tr('$', '').to_i
    #call function to get events here
    @to_search = false
    m = DataGet.new(@city, @date, @price)
    @data = m.final_data
    #call function to output first 5 values
    # puts "Thank you #{name}, one moment"
    # things_in = gets.chomp
    self.present_results(0, @data.size - 1)
    #asks for the user to input from a selection

    end
  end
end

a = InterfaceApp.new
a.user_interface_tm
