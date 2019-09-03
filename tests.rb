# frozen_string_literal: true

require 'test/unit'
require_relative 'poker'

class PokerTest < Test::Unit::TestCase
  # Create a new Customer and check if it's first_name is correct.

  def setup
    @poker = Poker.new(8, 'Ben Ulcoq', 'Robert Downey')
  end

  #   def test_players
  #       assert_equal(8, @poker.player_positions.length)
  #   end

  #   def test_args
  #       assert_equal('Ben Ulcoq', @poker.player_positions[0].player_name)
  #       assert_equal('Robert Downey', @poker.player_positions[1].player_name)
  #   end

  #   def test_hole_cards
  #       assert_equal(['2C', '4C'], @poker.player_positions[0].hole_cards)
  #   end

  # def test_flop
  #     assert_equal(['6H', '6S', '6D'], @poker.community_cards)
  # end

  # def test_turn
  #     assert_equal(['6H', '6S', '6D', '7H'], @poker.community_cards)
  # end

  def test_river
    assert_equal(%w[6H 6S 6D 7H 7D], @poker.community_cards)
  end

  # def test_fold
  #   assert_equal(false, @poker.player_positions[0].folded)
  # end

  # def test_call

  # end


    

end
