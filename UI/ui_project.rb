class InterfaceApp
  attr_accessor :city, :date, :price, :name, :data

  def user_selection
    puts "1. Favorite
    2. Show more
    3. New search
    4. Exit"
    puts "Please type the associated number for the choices above"

  end

  def present_results
    
  end

  def user_interface_tm
    puts "Welcome to Ticketmaster! Let us help you find local events! What is your name?"
    @name = gets.chomp
    User.create(name: @name)
    puts "Hi #{@name} please type in the city where you'd like to look:"
    @city = gets.chomp
    puts "What date for shows in #{@city}? (Format: yyyy-mm-dd)"
    @date = gets.chomp
    puts "Awesome! Around how much are you looking to spend?"
    @price = gets.chomp.tr('$', '')
    #call function to get events here
    dataI = DataGet.new(@city, @date, @price)
    @data = dataI.return_events_under_max


    #call function to output first 5 values
    #asks for the user to input from a selection

  end
end
