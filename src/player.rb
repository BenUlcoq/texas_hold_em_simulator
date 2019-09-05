# frozen_string_literal: true

class Player
  attr_reader :player_name
  attr_accessor :hole_cards, :folded, :chip_stack, :current_bet, :max_winnings, :strongest_hand, :acted, :max_pot

  def initialize(name)
    # Stores the name value passed to the instance initialisation into an instance variable @player_name.
    @player_name = name
    # Generates an empty array which cards can be passed into.
    @hole_cards = []
    # Creates a boolean variable used for checking whether a players hand has been folded.
    @folded = false
    # Initializes an integer variable used for tracking the number of chips the player has.
    @chip_stack = 5000
    # Initializes an integer variable used for tracking the amount the player has currently bet.
    @current_bet = 0
    # Initializes an integer variable used for tracking the maximum amount a player can win when they go all in.
    @max_winnings = 0
    # Initializes an integer variable used for calculating the maximum amount a player can win when they go all in.
    @max_pot = 0
    # Creates a boolean variable used for checking whether a player has performed an action in a round of betting.
    @acted = false
    # Generates an empty array which will store the player's strongest 5 card hand when calculated.
    @strongest_hand = []
  end
end
