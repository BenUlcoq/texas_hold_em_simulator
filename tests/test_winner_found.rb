# frozen_string_literal: true

require 'test/unit'
require_relative '../src/poker'

class PokerTest < Test::Unit::TestCase
  attr_accessor :poker

  def setup
    @poker = Poker.new(2, ['Ben Ulcoq', 'Darth Vader'])
  end

  def test_winner_found
    assert_equal(@poker.winner_found, ['true'])
  end
end
