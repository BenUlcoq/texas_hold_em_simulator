# frozen_string_literal: true

# Import Ruby Gems and necessary classes
require 'random_data'
require_relative 'deck'
require_relative 'player'
require_relative 'interface'
require 'ruby-poker'
require 'colorize'

class Poker
  attr_reader :player_positions, :deck, :community_cards, :active_players, :pot_size
  attr_accessor :table_current_bet

  def initialize(number_of_players, args)
    @hand_played = false
    @interface = Interface.new
    @big_blind_value = 50
    @small_blind_value = 25
    @pot_size = 0
    @committed = 0
    @table_current_bet = 0
    @stage_of_play = 0
    @active_players = []

    # Initializes an instance of the TTY Spinner class and stores it to a variable.

    # Passes the player details supplied via CLI to the @player_positions array upon initialization.
    @player_positions = args + Array.new(number_of_players - args.length)

    # Creates instances of the Player class within @player_positions and set their names depending on whether a name has been passed, or if it is random.
    @player_positions.map! do |name|
      if name
        Player.new(name)
      else
        Player.new("#{Random.firstname} #{Random.lastname}")
      end
    end
    # Runs the home screen method - entry into the application.
    run_home_screen
  end

  # The main methods which run the poker game.
  def play_poker
    # Checks to see that the players want to continue.
    while @game_running

      # Starts the hand.
      poker_hand

      # Once the hand is over we need to payout the winner.
      if @game_running
        # If we reach showdown we calculate everyone's best hands and then find the winner(s).
        if @active_players.length != 1
          best_hand
          determine_winner
        end
        # Once we know the winner(s) (or there's only one person left in the hand), we pay them out.
        payout
        # Rotate the player positions so the blinds change.
        @player_positions.rotate!
        # Lets the game know that the welcome message isn't needed any more - we just want to play poker!
        @hand_played = true
      else
        break
      end

    end

    # Still playing? Good! Let's go again.
    play_poker if @game_running

    # The game is no longer running - let's head home.
    run_home_screen
  end

  # Runs the main flow control of a hand of poker.
  def poker_hand
    # If a hand hasn't been played yet, display a welcome message with some key information.
    @interface.welcome_message(@player_positions) unless @hand_played

    # Do the players want to start a new hand?
    new_hand_check

    # If they do, let's play!
    if @game_running

      # Resets and reinitializes everything required for the start of a new hand.
      zero_chips
      reset_values
      set_blinds
      init_deck
      deal_hole_cards
      system 'clear'
      puts 'Dealing the cards..'
      sleep(2)

      # Starts a loop that checks to see whether a winner needs to be determined.
      while @active_players.length > 1 && @stage_of_play < 4
          # Each time it loops back to this point means we've progressed to the next stage of play and cards need to be dealt.
          deal_community_cards

          # If a player has gone all in in the last round of betting, sets the maximum amount that player can win this hand.
          @active_players.map do |player|
            next unless player.chip_stack == 0 && player.max_pot != 0

            player.max_winnings = (@pot_size - @committed) + (player.max_pot * @active_players.length)
            player.max_pot = 0
          end

          # Resets the committed value AFTER max_winnings has been calculated.
          @committed = 0 if @stage_of_play.positive?

          loop do
            # If a player has folded they are no longer active in this hand.
            @active_players.map do |player|
              @active_players.delete(player) if player.folded == true
            end

            # If a player is still active and has no chips left, they are all in.
            @all_in_players = 0
            @active_players.map do |player|
              @all_in_players += 1 if player.chip_stack == 0
            end

            # If the player is all in and there are players who aren't all in rotate the array to check the next player.
            if @active_players[0].acted == true && @active_players[0].chip_stack.zero? && @active_players.length != @all_in_players
              @active_players.rotate!

            # If the player was the initial raiser and they haven't had their bet raised, move onto the next stage of the hand.
            elsif (@active_players[0].acted == true) && (@active_players[0].current_bet == @table_current_bet)
              @stage_of_play += 1

              # Resets everyone so they haven't acted for the next round of betting, except for those who are all in.
              @active_players.map do |player|
                if player.current_bet == @table_current_bet
                  player.acted = false unless player.chip_stack.zero?
                end
                player.current_bet = 0
              end
              @table_current_bet = 0
              break

            else
              # If all of the above conditions fail, it means the player needs to make a move.
              @interface.ready_check(@active_players[0])
              player_action
            end
          end
        end
      end
    end
  end

# ******  VARIABLE ADJUSTMENTS AND SETTINGS HERE  ******

# Resets various values to their defaults for the start of a new hand.
def reset_values
  @pot_size = 0
  @committed = 0
  @table_current_bet = 0
  @stage_of_play = 0
  @active_players = @player_positions.clone
  @active_players.map do |player|
    player.hole_cards = []
    player.folded = false
    player.current_bet = 0
    player.max_winnings = 0
    player.max_pot = 0
    player.acted = false
    player.strongest_hand = []
  end
end

# Sets the blinds and adjust the bet and pot sizing.
def set_blinds
  @active_players[0].current_bet = @small_blind_value
  @active_players[1].current_bet = @big_blind_value
  @table_current_bet = @active_players[1].current_bet
  @pot_size += @active_players[0].current_bet + @active_players[1].current_bet
  @committed += @pot_size
  @active_players.rotate!(2)
end

# ******  CARD/DECK/HAND MANIPULATION METHODS  ******

# Defines a method for initializing an instance of the Deck class.
def init_deck
  @deck = Deck.new
end

# Defines a method for dealing cards to each player.
def deal_hole_cards
  # Initiates a loop, iterating over each player within the active players array.
  @active_players.map do |player|
    # Removes any persistent cards from the player's hands.
    player.hole_cards.clear
  end
  # Initiates a loop that will repeat twice.
  2.times do
    # Initiates a loop, iterating over each player with the active players array.
    @active_players.map do |player|
      # Moves a card from the top of the deckto the current player's hand.
      player.hole_cards.push(@deck.cards.shift)
    end
  end
end

# Defines a method for dealing three cards from the top of the deck to the community table cards.
def deal_flop
  p @player_positions
  p @active_players
  STDIN.gets.chomp
  # Burns the top card of the deck.
  @deck.cards.shift
  # Moves the top three cards of the deck into the community table cards array.
  @community_cards = @deck.cards.shift(3)
  puts ''
  print 'The flop is: '
  @interface.card_output(@community_cards)
  sleep(3)
end

# Defines a method for dealing a single card from the top of the deck to the comunity table cards.
def deal_post_flop
  # Burns the top card of the deck.
  @deck.cards.shift
  # Moves the top card of the deck into the community table cards array.
  @community_cards.push(@deck.cards.shift)
  print 'The community cards are: '
  @interface.card_output(@community_cards)
  sleep(3)
end

# Determines what stage play is currently at and deals the appropriate number of cards with an appropriate message.
def deal_community_cards
  if @stage_of_play == 1
    puts 'The flop is now being being dealt.'
    sleep(1)
    deal_flop
  elsif @stage_of_play == 2
    puts 'The turn is now being being dealt.'
    sleep(1)
    deal_post_flop
  elsif @stage_of_play == 3
    puts 'The river is now being dealt.'
    sleep(1)
    deal_post_flop
  end
end

# ******  SUPPLEMENTARY LOGIC METHODS  ******

# Checks if any of the players do not have any chips left. If a player has no chips, they are removed from the game.
def zero_chips
  @player_positions.each do |player|
    @player_positions.delete(player) if player.chip_stack.zero?
  end
end

# Compares the hands of the players remaining in the hand and sorts the array from strongest hand to weakest hand.
def determine_winner
  @active_players.sort! do |player1, player2|
    if player1.strongest_hand > player2.strongest_hand
      -1
    elsif player1.strongest_hand < player2.strongest_hand
      1
    else
      0
    end
  end
end

# Checks all of the possible 5-card hands a player could have using their hole cards along with the community cards.
def best_hand
  @active_players.map do |player|
    # Creates an array storing all possible 5 card combinations.
    @all_combos = (player.hole_cards + @community_cards).combination(5).to_a
    @best_hand = PokerHand.new
    @current_hand = nil

    # Loops through every hand combination, comparing the current hand to the best hand. If the current hand is better than the best hand, it becomes the best hand, otherwise it is deleted.
    @all_combos.map do |hand|
      next unless @all_combos.length > 1

      @current_hand = PokerHand.new(hand)
      if @current_hand > @best_hand
        @best_hand = @current_hand
      else
        @all_combos.delete(hand)
      end
    end

    # After finding the best hand it stores it for the player and outputs it.
    player.strongest_hand = @best_hand
    puts "#{player.player_name} has #{player.strongest_hand}"
    sleep(1)
  end
end

# ******  USER INPUT METHODS  ******

# Runs a check to see if the players want to start a new hand.
def new_hand_check
  puts 'Are you ready to play? Enter ' + '(Y)es'.light_green + ' to proceed or ' + '(N)o'.light_red + ' to return to the main menu.'
  @input = STDIN.gets.chomp
  if @input.downcase == 'y' || @input.downcase == 'yes'
    @game_running = true
  elsif @input.downcase == 'n' || @input.downcase == 'no'
    @game_running = false
  else
    puts 'Please enter a valid input.'
    new_hand_check
  end
end

# Defines a method for displaying the home screen and retreiving input related to the homescreen options.
def run_home_screen
  @interface.home_screen

  # Loop that will receive user input and check whether it is valid.
  loop do
    @input = STDIN.gets.chomp
    if @input.downcase == 'p' || @input.downcase == 'play'
      @game_running = true
      play_poker
      break
    elsif @input.downcase == 'r' || @input.downcase == 'rules'
      @interface.poker_rules
      run_home_screen
      break
    elsif @input.downcase == 'q' || @input.downcase == 'quit'
      break
    else
      puts 'Please enter a valid command!'
    end
  end
  system 'exit'
end

# Outputs information to the player regarding the current situation within the hand and their current status, including available options.
def player_action
  loop do
    @input = STDIN.gets.chomp
    # Checks to see if the user is in a safe position to view their hand.
    if @input.downcase == 'y' || @input.downcase == 'yes'

      # Outputs all of the necessary information for the user.
      @interface.player_info(@active_players[0], @pot_size)
      @interface.current_info(@active_players, @table_current_bet)

      # If community cards have been dealt yet, output them for the user in a nice format.
      if @stage_of_play.positive?
        print 'The current community cards are '
        @interface.card_output(@community_cards)
        puts ''
      end
      puts ''
      print 'You have the '
      # Outputs the user's hole cards in a nice format.
      @interface.card_output(@active_players[0].hole_cards)

      puts ''
      puts ''

      puts 'What you you like to do?'
      # If the player has already acted this turn and their bet is equal to the highest bet, it means that they were the initial raiser (or checker).
      # So we break out of the loop asking for input so we can move to the next stage of the hand.
      if @active_players[0].acted == true && @active_players[0].current_bet == @table_current_bet
        # && @active_players[0].current_bet.positive?
        break

      # If we get to here and the player's current bet is equal to the tables highest bet, it means they're the first to act this turn, or they are the big blind and no one has bet.
      # Although a user is allowed to fold here, we don't provide the option as it is 100% free to check here with no downside.
      elsif @active_players[0].current_bet == @table_current_bet
        puts 'You can ' + '(C)heck'.light_yellow + ' or ' + '(R)aise.'.light_green

        loop do
          @input = STDIN.gets.chomp

          # If the player chooses to check, we adjust chips (using check_action) and rotate the @active_players array to move onto the next player.
          if @input.downcase == 'c' || @input.downcase == 'check'
            check_action
            @active_players.rotate!
            break

          # If the player chooses to raise, we adjust chips (using raise_action)
          elsif @input.downcase == 'r' || @input.downcase == 'raise'
            raise_bet
            # If @input_string is true, it means that the player has entered a correct value so we rotate the array and break out of the loop.
            # Otherwise, the player has changed their mind regarding the raise and wants to see the options again, so we don't rotate/break out.
            unless @input_string
              @active_players.rotate!
              break
            end
          else
            puts 'Please enter a valid input.'.light_red
          end
        end

        # Break out of asking for user input - the user input has already been entered.
        # Don't worry, we'll be back soon doing the same thing for the next player (if needed!)
        break

      # If the player's current bet is below the highest bet, they can't check, so we offer all other options.
      elsif @active_players[0].current_bet < @table_current_bet
        puts 'You can ' + '(C)all, '.light_yellow + '(R)aise,'.light_green + ' or ' + '(F)old.'.light_red

        loop do
          @input = STDIN.gets.chomp
          # Behaviour here is the same as checking/raising above - we just call different methods to adjust chips as necessary.
          if @input.downcase == 'c' || @input.downcase == 'call'
            call_bet
            @active_players.rotate!
            break
          elsif @input.downcase == 'r' || @input.downcase == 'raise'
            raise_bet
            unless @input_string
              @active_players.rotate!
              break
            end
          elsif @input.downcase == 'f' || @input.downcase == 'fold'
            fold_hand
            @active_players.rotate!
            break
          else
            puts 'Please enter a valid input.'
          end
        end
        break
      end
      # This means the player has entered a response other than Yes when asked if they want to view their hand.
      # Exiting out of the game mid hand would have disastrous effects on chip calculations so we just wait until they say yes!
    else
      puts "That's okay - no rush!"
    end
  end
end

# ******  CHIP COUNT MANIPULATION METHODS  ******

# Makes all of the necessary adjustments to the pot, chip stack.
# Also lets the game know that the player has performed an action this round.
# 'Committed' is used for max winnings calculations regarding all-ins.
def pot_adjustment
  @committed += @active_players[0].current_bet unless @active_players[0].folded
  @pot_size += @active_players[0].current_bet
  @active_players[0].chip_stack -= @active_players[0].current_bet
  @active_players[0].acted = true
end

# If the player is checking nothing needs to happen.
# We say they've acted so we can see if it checks back round to them.
def check_action
  @active_players[0].acted = true
  system 'clear'
  puts 'You have checked.'
  sleep(3)
end

# Sets the player to 'folded' and adjusts chips.
def fold_hand
  @active_players[0].folded = true
  pot_adjustment
  @active_players[0].current_bet = 0
  @active_players[0].acted = false
  system 'clear'
  puts 'You have folded your hand.'
  sleep(3)
end

# Set's the players current bet to equal the highest bet and adjusts chips.
def call_bet
  # Before we can adjust things we need to take away the player's (original) current bet from a few places.
  # This is so we don't add chips into the pot that don't exist!
  @pot_size -= @active_players[0].current_bet
  @committed -= @active_players[0].current_bet

  # If the current bet is more than the player's chip stack it means they need to go all in.
  if @active_players[0].chip_stack <= @table_current_bet
    all_in

  # If not, they can call the current bet as normal!
  else
    @active_players[0].current_bet = @table_current_bet
    pot_adjustment
    system 'clear'
    puts 'You have called the current bet.'
    sleep(3)
  end
end

# The player has chosen to raise the bet - now what?
def raise_bet
  # We need to see how much they want to bet.
  puts 'How much would you like to raise? Or enter (B)ack to change your mind.'
  loop do
    @input_string = STDIN.gets.chomp

    # Checks to make sure the value they entered can be converted into an integer.
    # If it can, store it in a new variable.
    @input = begin
              Integer(@input_string)
             rescue StandardError
               false
            end

    # Makes sure that the raise is a legal move.
    if @input && @input >= @table_current_bet * 2
      # Same as with a call, don't want to duplicate chips.
      @pot_size -= @active_players[0].current_bet
      @committed -= @active_players[0].current_bet

      # Checks to see if they're going all in.
      if @active_players[0].chip_stack <= @input
        all_in
      else
        # Otherwise, sets the raise values and adjusts chip counts.
        @active_players[0].current_bet = @input
        @table_current_bet = @active_players[0].current_bet
        pot_adjustment
        system 'clear'
        puts "You have raised the bet to #{@active_players[0].current_bet} chips."
        sleep(3)
      end
      # Sets the user input to nil so the parent method knows a raise has been made and breaks the loop.
      @input_string = nil
      break
    # If the raise isn't legal we let the player know so they can try again.
    elsif @input && @input <= @table_current_bet * 2
      puts "Please enter a valid raise amount - your raise must be at least twice the current bet. The current bet is #{@table_current_bet} chips."
    # If the player chickens out of the raise we can let them go back and change their mind ;)
    elsif @input_string.downcase == 'b' || @input_string.downcase == 'back'
      break
    else
      puts 'Please enter a valid, whole number'
    end
  end
end

# Lets the player know they're about to go all in.
def all_in
  puts 'You are about to go all in, are you sure? Enter ' + '(Y)es'.light_green + ' to proceed or ' + '(N)o'.light_red + ' to go back.'
  loop do
    @input = STDIN.gets.chomp
    if @input.downcase == 'y' || @input.downcase == 'yes'
      # Sets the all-in values.
      @active_players[0].current_bet = @active_players[0].chip_stack
      @table_current_bet = @active_players[0].current_bet

      # Sets a max-pot value for use in calculating the maximum amount a user can win after going all in.
      @active_players[0].max_pot = @active_players[0].current_bet
      pot_adjustment
      system 'clear'
      puts 'You have gone all in! Good Luck!'
      sleep(3)
      break

      # If the player wants to chicken out we ask for a different amount and break the loop.
    elsif @input.downcase == 'n' || @input.downcase == 'no'
      raise_bet
      break
    else
      puts 'Response not clear enough.'
    end
  end
end

# Since the active players array has been sorted by the player's hand strengths, we can pay out winners from top to bottom.
def payout
  until @pot_size.zero?

    # If the winning player has gone all in this round, they are only paid out the maximum amount they could possibly win from the pot.
    if @active_players[0].max_winnings < @pot_size && @active_players[0].max_winnings != 0
      puts "#{@active_players[0].player_name} won #{@active_players[0].max_winnings} with high hand: #{@active_players[0].strongest_hand}."
      @active_players[0].chip_stack += @active_players[0].max_winnings
      @pot_size -= @active_players[0].max_winnings
      @active_players[0].max_winnings = 0

      # Deletes the player who has been paid out from the array so that they do not get paid out twice.
      @active_players.shift

    # If the winning player didn't need to go all in, they simply win the whole pot.
    else
      if @active_players.length > 1
        puts "#{@active_players[0].player_name} won #{@pot_size} chips with high hand: #{@active_players[0].strongest_hand}."
      else
        puts "#{@active_players[0].player_name} won #{@pot_size} chips."
      end
      @active_players[0].chip_stack += @pot_size
      @pot_size = 0
      puts "#{@active_players[0].player_name} now has #{@active_players[0].chip_stack} chips."
    end
  end
end

# The End!
# end
