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

  # def test_river
  #   assert_equal(%w[6H 6S 6D 7H 7D], @poker.community_cards)
  # end

  # def test_fold
  #   assert_equal(false, @poker.player_positions[0].folded)
  # end

  # def test_winner
  #   system "clear"
  #   @poker.active_players.map do |player|
  #     puts "#{player.player_name} has #{player.strongest_hand}"
  #   end
  #   # puts "#{@poker.active_players[0].player_name} had #{@poker.active_players[0].strongest_hand}"
  #   # puts "#{@poker.active_players[1].player_name} had #{@poker.active_players[1].strongest_hand}"
  #   assert_equal(true, @poker.active_players[0].strongest_hand > @poker.active_players[1].strongest_hand)
  # end

  def test_chip_win
    assert_equal(true, @poker.active_players[0].chip_stack > 5000)
  end
  
  

end
