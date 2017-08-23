require_relative '../config/environment.rb'
require 'twilio-ruby'
require 'twitter'
require 'launchy'

class InterfaceApp
  attr_accessor :city, :date, :price, :name, :data, :to_search, :min, :max, :testBool, :user_instance, :phoneNumber, :testBoolEvent, :event_num

  def user_selection
    @testBool = true
    while @testBool == true
    puts "
    A. Select event
    B. Show more
    C. New search
    D. View Favorites
    E. Exit"
    puts "--------------" * 7
    puts "Please type the associated letter for the choices above"
    user_alphabet_answer = gets.chomp.upcase
    if user_alphabet_answer == "A" || user_alphabet_answer == "B" || user_alphabet_answer == "C" || user_alphabet_answer == "D" || user_alphabet_answer == "E" || user_alphabet_answer == "F" || user_alphabet_answer == "G" || user_alphabet_answer == "H"
      self.selection_switch(user_alphabet_answer)
      @testBool = false
    else
      puts "Please enter a correct letter!"
    end
    end
  end


  def full_send
    account_sid = ""
    auth_token = ""
    client = Twilio::REST::Client.new account_sid, auth_token
    client.messages.create(
      from: "+12019034298",
      to: "+1#{@phoneNumber}",
      body: "Hi! Your friend #{@name} wants to share an event in #{@city} on #{@date}. Check it out #{@data[@event_num.to_i - 1][1]}"
      )
      puts "Message sent!"
      self.pull_up_event
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
    # puts "Please select the event number that you would like to save as your favorite."
    valid = true
    while valid
      event_selection = @event_num
      if event_selection.to_i < data.size - 1 && event_selection.to_i > 0
        create_everything(event_selection)
        valid = false
      end
    end
    self.pull_up_event
    self.user_selection
  end

  def view_favorites
    all = @user_instance.events
    all.each do |event|
      puts "#{event.name}"
    end
    self.user_selection
  end

  def send_to_friend
    # puts "Which event would you like to share (Please select the number associated with the event.)?"
    # answer = gets.chomp
    puts "What is your friend's phone number?"
    @phoneNumber = gets.chomp
    self.full_send
  end

  def actually_tweet(handle)

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ""
      config.consumer_secret     = ""
      config.access_token        = ""
      config.access_token_secret = ""
    end

    client.update("#{handle} is going to #{@data[@event_num.to_i - 1][0]} in #{city}!")
    puts "Tweet sent!"
  end

  def send_tweet
    puts "Please type in your Twitter handle."
    twitter_handle = gets.chomp
    self.actually_tweet(twitter_handle)
    self.pull_up_event
    self.user_selection
  end

  def take_me_to_event_page
    Launchy.open("#{@data[@event_num.to_i - 1][1]}")
    self.pull_up_event
    self.user_selection
  end


  def user_selection_event
    @testBoolEvent = true
    while @testBoolEvent == true
    puts "
    A. Make favorite
    B. Share an event with a friend
    C. Let everyone know you're going to an event
    D. Buy tickets for event
    E. Go back"
    puts "Please type the associated letter for the choices above"
    user_alphabet_answer = gets.chomp.upcase
    if user_alphabet_answer == "A" || user_alphabet_answer == "B" || user_alphabet_answer == "C" || user_alphabet_answer == "D" || user_alphabet_answer == "E"
      self.selection_switch_event(user_alphabet_answer)
      @testBoolEvent = false
    else
      puts "Please enter a correct letter!"
    end
    end
  end



  def selection_switch_event(letter)
    case letter
    when "A"
      self.adding_to_favorites
    when "B"
      self.send_to_friend
    when "C"
      system "clear"
      self.send_tweet
    when "D"
      self.take_me_to_event_page
    when "E"
      system "clear"
      self.present_results
      self.user_selection
    end
  end

  def pull_up_event
    @data[@event_num.to_i - 1].each do |val|
      puts val
    end
    self.user_selection_event
  end


  def selection_switch(letter)
    case letter
    when "A"
      puts "Please select the number of the event you would like to see."
      @event_num = gets.chomp
      system "clear"
      self.pull_up_event
    when "B"
      @min += 5
      self.present_results(@min, @max)
    when "C"
      system "clear"
      @to_search = true
    when "D"
      system "clear"
      self.view_favorites
    when "E"
      system "clear"
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
    puts "--------------" * 7
    self.user_selection
  end



  def user_interface_tm
    @to_search = true
    system "clear"
    puts "Welcome to Ticketmaster! Let us help you find local events! What is your name?"
    @name = gets.chomp.titleize
    system "clear"
    @user_instance = User.find_or_create_by(name: @name)
    # User.create(name: @name)
    while @to_search == true
    puts "Hi #{@name}, please type in the city where you'd like to look:"
    @city = gets.chomp.titleize
    system "clear"
    puts "What date for shows in #{@city}? (Format: yyyy-mm-dd)"
    @date = gets.chomp
    system "clear"
    puts "Awesome! Around how much are you looking to spend?"
    @price = gets.chomp.tr('$', '').to_i
    puts "Please wait as we load the events..."
    #call function to get events here
    @to_search = false
    m = DataGet.new(@city, @date, @price)
    @data = m.final_data
    #call function to output first 5 values
    # puts "Thank you #{name}, one moment"
    # things_in = gets.chomp
    system "clear"
    self.present_results(0, @data.size - 1)
    #asks for the user to input from a selection

    end
  end
end

a = InterfaceApp.new
a.user_interface_tm
