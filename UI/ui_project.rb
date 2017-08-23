require_relative '../config/environment.rb'

class InterfaceApp
  attr_accessor :city, :date, :price, :name, :data, :to_search, :min, :max, :testBool, :user_instance

  def user_selection
    @testBool = true
    while @testBool == true
    puts "
    A. Make favorite
    B. Show more
    C. New search
    D. View Favorites
    E. Exit"
    puts "Please type the associated letter for the choices above"
    user_alphabet_answer = gets.chomp.upcase
    if user_alphabet_answer == "A" || user_alphabet_answer == "B" || user_alphabet_answer == "C" || user_alphabet_answer == "D" || user_alphabet_answer == "E"
      self.selection_switch(user_alphabet_answer)
      @testBool = false
    else
      puts "Please enter a correct letter!"
    end
    end
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
