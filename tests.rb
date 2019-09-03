require 'test/unit'
require_relative 'poker'

class PokerTest < Test::Unit::TestCase
    # Create a new Customer and check if it's first_name is correct.

    def setup
        @poker = Poker.new(3, 'Ben Ulcoq', 'Robert Downey')
    end

    def test_players
        assert_equal(3, @poker.player_positions.length)
    end

    def test_args
        assert_equal('Ben Ulcoq', @poker.player_positions[0])
        assert_equal('Robert Downey', @poker.player_positions[1])
        p @poker.player_positions[2]
    end

end