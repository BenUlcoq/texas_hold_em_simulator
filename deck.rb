# frozen_string_literal: true

class Deck
  attr_accessor :deck

  def initialize
    @ranks = [*(2..9), 'T', 'J', 'Q', 'K', 'A']
    @suits = %w[C H S D]
    @deck = []

    @ranks.each do |rank|
      @suits.each do |suit|
        @deck << "#{rank}#{suit}"
      end
    end
  end

  # @deck.shuffle!
end
