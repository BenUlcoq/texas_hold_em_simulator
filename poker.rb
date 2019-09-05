# frozen_string_literal: true

# Import Ruby Gems and necessary classes
require 'random_data'
require_relative 'deck'
require_relative 'player'
require_relative 'interface'
require 'ruby-poker'
require 'colorize'
require 'tty-spinner'

class Poker
  attr_reader :player_positions, :deck, :community_cards, :active_players, :pot_size
  attr_accessor :table_current_bet

  
  def initialize(number_of_players, args)
    # Initializes an instance of the TTY Spinner class and stores it to a variable.
    @spinner = TTY::Spinner.new('Awaiting Input [:spinner]', format: :arrow_pulse)
    # Initializes an integer for tracking the number of hands that have been played.
    @hands_played = 0
    # Initializes an instance of the Interface class and stores it to a variable.
    @interface = Interface.new

    # Passes the player details supplied via CLI to the @player_positions array upon initialization.
    @player_positions = args + Array.new(number_of_players - args.length)
    # Loops through the @player_positions array.
    @player_positions.map! do |name|
      # Checks to see whether the current index contains a value.
      if name
        # Creates an instance of the Player class and passes the current iteration's value.
        Player.new(name)
      else
        # Creates an instance of the Player class and passes a randomly generated name value.
        Player.new("#{Random.firstname} #{Random.lastname}")
      end
    end
    # Calls the run_home_screen method.
    run_home_screen
  end

  # Defines a method
  def run_home_screen
    @interface.home_screen
    @spinner.auto_spin
    loop do
      @input = STDIN.gets.chomp
      if @input.downcase == 'p' || @input.downcase == 'play'
        @spinner.success('Launching Game..')
        sleep(1)
        @game_running = true
        play_poker
        break
      elsif @input.downcase == 'r' || @input.downcase == 'rules'
        @spinner.success('Opening Rules..')
        sleep(1)
        @interface.poker_rules
        run_home_screen
        break
      elsif @input.downcase == 'q' || @input.downcase == 'quit'
        @spinner.success('See you next time!')
        sleep(1)
        break
      else
        puts 'Please enter a valid command!'
      end
    end
    system 'exit'
  end

  # Defines a method containing the flow control for a hand of poker.
  def play_poker
    @player_positions.map do |player|
      @player_positions.delete(player) if player.chip_stack.zero?
    end
    @big_blind_value = 50
    @small_blind_value = 25
    @pot_size = 0
    @table_current_bet = 0
    @stage_of_play = 0
    @active_players = @player_positions.dup
    init_deck
    deal_hole_cards
    while @game_running == true
      poker_hand
      if @game_running == true
        if @active_players.length != 1
          best_hand
          determine_winner
        end
        payout
        @player_positions.rotate!
        @hands_played += 1
        play_poker
      else
        break
      end

    end
  end

  def payout
    until @pot_size.zero?
      if @active_players[0].max_winnings < @pot_size && @active_players[0].max_winnings != 0
        puts "#{@active_players[0].player_name} won #{@active_players[0].max_winnings} with high hand: #{@active_players[0].strongest_hand}."
        @active_players[0].chip_stack += @active_players[0].max_winnings
        @pot_size -= @active_players[0].max_winnings
        @active_players[0].max_winnings = 0
        @active_players.shift
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

  def set_blinds
    @active_players[0].current_bet = @small_blind_value
    @active_players[1].current_bet = @big_blind_value
    @table_current_bet = @active_players[1].current_bet
    @pot_size += @active_players[0].current_bet + @active_players[1].current_bet
    @active_players.rotate!(2)
  end

  def new_hand_check
    puts 'Are you ready to play? Enter ' + '(Y)es'.light_green + ' to proceed or ' + '(N)o'.light_red + ' to return to the main menu.'
    @spinner.auto_spin
    @input = STDIN.gets.chomp
    if @input.downcase == 'y' || @input.downcase == 'yes'
      @game_running = true
      @spinner.success('Commencing next hand..')
      sleep(1)
    elsif @input.downcase == 'n' || @input.downcase == 'no'
      @game_running = false
      @spinner.success('Returning home..')
      sleep(1)
      run_home_screen
    else
      puts 'Please enter a valid input.'
      new_hand_check
    end
  end

  def deal_community_cards
    if @stage_of_play == 1
      puts 'The flop is now being being dealt.'
      sleep(1)
      deal_flop
    elsif @stage_of_play == 2 && @community_cards.length != 4
      puts 'The turn is now being being dealt.'
      sleep(1)
      deal_post_flop
    elsif @stage_of_play == 3 && @community_cards.length != 5
      puts 'The river is now being dealt.'
      sleep(1)
      deal_post_flop
    end
  end

  def poker_hand
    @interface.welcome_message(@player_positions) if @hands_played.zero?

    new_hand_check
    if @game_running == true
      set_blinds

      while @active_players.length > 1 && @stage_of_play < 4

        deal_community_cards

        loop do
          @active_players.map do |player|
            @active_players.delete(player) if player.folded == true
          end

          @active_players.map do |player|
            if player.chip_stack == 0 && player.max_pot != 0
              player.max_winnings = (player.max_winnings * @active_players.length) + player.max_pot
              player.max_pot = 0
            end
          end

          if @active_players[0].acted == true && @active_players[0].chip_stack.zero?
            @active_players.rotate!

          elsif (@active_players[0].acted == true) && (@active_players[0].current_bet == @table_current_bet)

            @stage_of_play += 1
            @active_players.map do |player|
              if player.current_bet == @table_current_bet
                player.acted = false unless player.chip_stack.zero?
              end
              player.current_bet = 0
            end

            @table_current_bet = 0
            break

          else

            @interface.ready_check(@active_players[0])

            player_action

          end
        end
      end
    end
  end
end

# @active_players[0] if @active_players[0].length == 1

def pot_adjustment
  @pot_size += @active_players[0].current_bet
  @active_players[0].chip_stack -= @active_players[0].current_bet
  @active_players[0].acted = true
end

def chip_adjustment
  @table_current_bet = @active_players[0].current_bet
  pot_adjustment
end

def fold_hand
  @active_players[0].folded = true
  pot_adjustment
  @active_players[0].current_bet = 0
  system 'clear'
  puts 'You have folded your hand.'
  sleep(3)
end

def all_in
  puts 'You are about to go all in, are you sure? Enter ' + '(Y)es'.light_green + ' to proceed or ' + '(N)o'.light_red + ' to go back.'
  loop do
    @input = STDIN.gets.chomp
    if @input.downcase == 'y' || @input.downcase == 'yes'
      @spinner.success('Going all in!')
      sleep(1)
      @active_players[0].current_bet = @active_players[0].chip_stack
      @active_players[0].max_winnings = @active_players[0].current_bet
      @active_players[0].max_pot = @pot_size
      chip_adjustment
      system 'clear'
      puts 'You have gone all in! Good Luck!'
      sleep(3)
      break

    elsif @input.downcase == 'n' || @input.downcase == 'no'
      raise_bet
      break
    else
      puts 'Response not clear enough.'
    end
  end
end

def call_bet
  @pot_size -= @active_players[0].current_bet
  if @active_players[0].chip_stack <= @table_current_bet
    all_in
  else
    @active_players[0].current_bet = @table_current_bet
    chip_adjustment
    system 'clear'
    puts 'You have called the current bet.'
    sleep(3)
  end
end

def check_action
  @active_players[0].acted = true
  system 'clear'
  puts 'You have checked.'
  sleep(3)
end

def raise_bet
  puts 'How much would you like to raise? Or enter (B)ack to change your mind.'
  loop do
    @input_string = STDIN.gets.chomp

    @input = begin
               Integer(@input_string)
             rescue StandardError
               false
             end

    if @input && @input >= @table_current_bet * 2
      @pot_size -= @active_players[0].current_bet
      if @active_players[0].chip_stack <= @input
        all_in
      else
        @spinner.success('Raising the bet..')
        @active_players[0].current_bet = @input
        chip_adjustment
        system 'clear'
        puts "You have raised the bet to #{@active_players[0].current_bet} chips."
        sleep(3)
      end
      @input_string = nil
      break
    elsif @input && @input <= @table_current_bet * 2
      puts "Please enter a valid raise amount - your raise must be at least twice the current bet. Current bet is #{@table_current_bet}"
    elsif @input_string.downcase == 'b' || @input_string.downcase == 'back'
      break
    else
      puts 'Please enter a valid, whole number'
    end
  end
end

def best_hand
  @active_players.map do |player|
    next unless @stage_of_play.positive?

    @all_combos = (player.hole_cards + @community_cards).combination(5).to_a
    @best_hand = PokerHand.new
    @current_hand = nil

    @all_combos.map do |hand|
      next unless @all_combos.length > 1

      @current_hand = PokerHand.new(hand)
      if @current_hand > @best_hand
        @best_hand = @current_hand
      else
        @all_combos.delete(hand)
      end
    end

    player.strongest_hand = @best_hand
    puts "#{player.player_name} has #{player.strongest_hand}"
    sleep(1)
  end
end

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

def player_action
  @spinner.auto_spin
  loop do
    @input = STDIN.gets.chomp

    if @input.downcase == 'y' || @input.downcase == 'yes'
      @spinner.success('')
      @interface.player_info(@active_players[0], @pot_size)
      @interface.current_info(@active_players, @table_current_bet)

      if @stage_of_play.positive?
        print 'The current community cards are '
        @interface.card_output(@community_cards)
        puts ''
      end
      puts ''
      print 'You have the '
      @interface.card_output(@active_players[0].hole_cards)

      puts ''
      puts ''

      puts 'What you you like to do?'
      if @active_players[0].acted == true && @active_players[0].current_bet == @table_current_bet && @active_players[0].current_bet.positive?
        break

      elsif @active_players[0].current_bet == @table_current_bet
        puts 'You can ' + '(C)heck'.light_yellow + ' or ' + '(R)aise.'.light_green
        @spinner.auto_spin
        loop do
          @input = STDIN.gets.chomp

          if @input.downcase == 'c' || @input.downcase == 'check'
            @spinner.success('Checking..')
            sleep(1)
            check_action
            @active_players.rotate!
            break

          elsif @input.downcase == 'r' || @input.downcase == 'raise'
            @spinner.success('Raising..')
            sleep(1)
            raise_bet
            unless @input_string
              @active_players.rotate!
              break
            end
          else
            puts 'Please enter a valid input.'.light_red
          end
        end
        break
      elsif @active_players[0].current_bet < @table_current_bet
        puts 'You can ' + '(C)all, '.light_yellow + '(R)aise,'.light_green + ' or ' + '(F)old.'.light_red
        @spinner.auto_spin
        loop do
          @input = STDIN.gets.chomp

          if @input.downcase == 'c' || @input.downcase == 'call'
            @spinner.success('Calling..')
            sleep(1)
            call_bet
            @active_players.rotate!
            break
          elsif @input.downcase == 'r' || @input.downcase == 'raise'
            @spinner.success('Raising..')
            sleep(1)
            raise_bet
            unless @input_string
              @active_players.rotate!
              break
            end
          elsif @input.downcase == 'f' || @input.downcase == 'fold'
            @spinner.success('Folding..')
            sleep(1)
            fold_hand
            @active_players.rotate!
            break
          else
            puts 'Please enter a valid input.'
          end
        end
        break
      end
    else
      puts "That's okay - no rush!"
    end
  end
end
