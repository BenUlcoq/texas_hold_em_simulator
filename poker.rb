# frozen_string_literal: true

# Import Ruby Gem: Random Data
require 'random_data'
require_relative 'deck'
require_relative 'player'

class Poker
  attr_reader :table, :player_positions, :flop
  attr_accessor :deck, :community_cards

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

    home_screen
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
    # Initiates a loop, iterating over each player within the player_positions array.
    @player_positions.map do |player|
      # Removes any persistent cards from the player's hands.
      player.hole_cards.clear
    end
    # Initiates a loop that will repeat twice.
    2.times do
      # Initiates a loop, iterating over each player with the player_positions array.
      @player_positions.map do |player|
        # Moves a card from the top of the deck.deck to the current player's hand.
        player.hole_cards.push(@deck.deck.shift)
      end
    end
  end

  def deal_flop
    @deck.deck.shift
    @community_cards = @deck.deck.shift(3)
  end

  def deal_post_flop
    @deck.deck.shift
    @community_cards.push(@deck.deck.shift)
  end

  def play_poker
    init_deck
    deal_hole_cards
    deal_flop
    deal_post_flop
    deal_post_flop
  end
end
