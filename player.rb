# frozen_string_literal: true

class Player
  attr_reader :player_name
  attr_accessor :hole_cards, :folded, :chip_stack, :current_bet, :max_winnings, :strongest_hand, :acted, :pretty_cards

  def initialize(name)
    # Stores the name value passed to the instance initialisation into an instance variable @player_name.
    @player_name = name
    # Generates an empty array which cards can be passed into.
    @hole_cards = []
    # Creates a boolean variable used for checking whether a players hand has been folded.
    @folded = false
    # Initialises an integer variable used for tracking the number of chips the player has.
    @chip_stack = 5000
    # Initialises an integer variable used for tracking the amount the player has currently bet.
    @current_bet = 0
    @max_winnings = 0
    @acted = false
    @strongest_hand = []
  end

  
end
