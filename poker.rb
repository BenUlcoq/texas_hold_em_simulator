# frozen_string_literal: true

# Import Ruby Gem: Random Data
require 'random_data'
require_relative 'deck'
require_relative 'player'

class Poker
  attr_reader :player_positions, :deck, :community_cards
  attr_accessor :table_current_bet

  # Passes the player details supplied to the @player_positions array upon initialization.
  def initialize(number_of_players, *args)
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
    @big_blind_value = 50
    @small_blind_value = 25

    home_screen
  end

  # Defines a method containing the flow control for a hand of poker.
  def play_poker
    @pot_size = 0
    @table_current_bet = 0
    @stage_of_play = 0
    @initial_raiser = nil
    @player_positions.rotate!
    @active_players = @player_positions.dup
    init_deck
    deal_hole_cards
    poker_hand
    @active_players.map do |player|
      puts "#{player.player_name} had #{player.hole_cards}"
    end
    puts "The table cards were #{community_cards}"
  end

  def poker_hand
    @active_players[0].current_bet = @small_blind_value
    @active_players[1].current_bet = @big_blind_value
    @table_current_bet = @active_players[1].current_bet
    @active_players.rotate!(2)

    while @active_players.length > 1 && @stage_of_play < 4

      puts "#{community_cards}"
      if @stage_of_play == 1
        deal_flop
      elsif @stage_of_play == 2 && @community_cards.length != 4
        deal_post_flop
      elsif @stage_of_play == 3 && @community_cards.length != 5
        deal_post_flop
      end

      loop do
        @active_players.map do |player|
          if player.current_bet == @table_current_bet
            player.acted == false unless player.chip_stack == 0
          end
          @active_players.delete(player) if player.folded == true
        end

        if @active_players[0].acted == true && @active_players[0].current_bet == @table_current_bet
          @stage_of_play += 1
          @active_players.map do |player|
            player.current_bet = 0
          end
          @table_current_bet = 0
          break
        elsif @active_players[0].acted == true && @active_players[0].chip_stack == 0
          @active_players[0].rotate!
        else
          loop do
            system 'clear'
            puts "#{@active_players[0].player_name}, are you ready to act?"
            puts 'Enter (Y)es to continue'
            @input = gets.chomp

            if @input.downcase == 'y' || @input.downcase == 'yes'
              system 'clear'
              puts "#{@active_players[0].player_name}, it is your turn to act."
              puts "The total pot size (including current bets) is #{@pot_size} chips."
              puts "You have #{@active_players[0].chip_stack} chips."
              if @table_current_bet > 0
                puts "The current bet is #{table_current_bet}"
              else
                puts 'There has been no betting yet this round.'
              end

              if @stage_of_play > 0
                puts "The current community cards are #{@community_cards.join(' ')}"
              end

              puts "You have #{@active_players[0].hole_cards.join(' and ')}"
              puts 'What you you like to do?'

              if @active_players[0].current_bet == @table_current_bet && @active_players[0].acted == true
                break

              elsif @active_players[0].current_bet == @table_current_bet
                loop do
                  puts 'You can (C)heck or (R)aise.'
                  @input = gets.chomp

                  if @input.downcase == 'c' || @input.downcase == 'check'
                    check_action
                    @active_players.rotate!
                    break

                  elsif @input.downcase == 'r' || @input.downcase == 'raise'
                    raise_bet
                    @active_players.rotate!
                    break
                  else
                    puts 'Please enter a valid input.'
                  end
                  @active_players.rotate!
                  break
                end
                break
              elsif @active_players[0].current_bet < @table_current_bet
                loop do
                  puts 'You can (C)all, (R)aise, or (F)old.'
                  @input = gets.chomp

                  if @input.downcase == 'c' || @input.downcase == 'call'
                    call_bet
                    @active_players.rotate!
                    break
                  elsif @input.downcase == 'r' || @input.downcase == 'raise'
                    raise_bet
                    @active_players.rotate!
                    break
                  elsif @input.downcase == 'f' || @input.downcase == 'fold'
                    fold_hand
                    @active_players.rotate!
                    break
                  end
                end
                break
              end
            else
              puts "That's okay - no rush!"
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
    puts 'You have folded your hand.'
  end

  def all_in
    loop do
      puts 'You are about to go all in, are you sure? Enter (Y)es to proceed.'
      @input = gets.chomp
      if @input.downcase == 'y' || @input.downcase == 'yes'
        @active_players[0].current_bet = @active_players[0].chip_stack
        chip_adjustment
        puts 'You have gone all in.'
        break
        # @active_players[0].max_winnings = @pot_size
      else
        puts 'Response not clear enough.'
      end
    end
  end

  def call_bet
    if @active_players[0].chip_stack <= @table_current_bet
      all_in
    else
      @active_players[0].current_bet = @table_current_bet
      chip_adjustment
      puts 'You have called the current bet.'
    end
  end

  def check_action
    @active_players[0].acted = true
    puts 'You have checked.'
  end

  def raise_bet
    loop do
      puts 'How much would you like to raise?'
      @input = gets.chomp

      if Integer(@input) && Integer(@input) >= @table_current_bet * 2
        if @active_players[0].chip_stack <= @table_current_bet
          all_in
          break
        else
          @active_players[0].current_bet = Integer(@input)
          chip_adjustment
          break
        end
      elsif Integer(@input) && Integer(@input) <= @table_current_bet * 2
        puts "Please enter a valid raise amount - your raise must be at least twice the current bet. Current bet is #{@table_current_bet}"
      else
        puts 'Please enter a valid, whole number'
      end
    end
  end

  # Defines a method for launching the homescreen of the application.
  def home_screen
    puts "Welcome to Texas Hold 'Em Simulator!"
    play_poker if gets.chomp == 'play'
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
  end

  # Defines a method for dealing a single card from the top of the deck to the comunity table cards.
  def deal_post_flop
    # Burns the top card of the deck.
    @deck.cards.shift
    # Moves the top card of the deck into the community table cards array.
    @community_cards.push(@deck.cards.shift)
  end

  def player_action; end
end
