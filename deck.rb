# frozen_string_literal: true

class Deck
  attr_accessor :cards

  def initialize
    #Generates a rank array containing all values found in a deck of cards.
    @ranks = [*(2..9), 'T', 'J', 'Q', 'K', 'A']
    # Generates a suits array containing all suits found in a deck of cards.
    @suits = %w[C H S D]
    # Initialises an empty cards array.
    @cards = []

    # Initiates a loop iterating through the rank array.
    @ranks.each do |rank|
      #Initiates a loop iterating through the suits array.
      @suits.each do |suit|
        # Passes the current suit and rank combination generated from the loops into the deck array.
        @cards << "#{rank}#{suit}"
      end
    end
    #Shuffles the deck array into a random order.
    @cards.shuffle!
  end
end
