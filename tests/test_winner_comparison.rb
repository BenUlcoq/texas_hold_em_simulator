# frozen_string_literal: true

require 'test/unit'
require_relative '../src/poker'

class PokerTest < Test::Unit::TestCase
  attr_accessor :poker

  def setup
    @poker = Poker.new(2, ['Ben Ulcoq', 'Darth Vader'])
  end

  def test_winner_comparison
    assert_equal(true, @poker.active_players[0].strongest_hand > @poker.active_players[1].strongest_hand)
  end
end
