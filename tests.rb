require 'test/unit'
require_relative 'poker'

class PokerTest < Test::Unit::TestCase
    # Create a new Customer and check if it's first_name is correct.

    def setup
        @poker = Poker.new(8, 'Ben Ulcoq', 'Robert Downey')
    end

    def test_players
        assert_equal(8, @poker.table.player_positions.length)
    end

    def test_args
        assert_equal('Ben Ulcoq', @poker.table.player_positions[0].player_name)
        assert_equal('Robert Downey', @poker.table.player_positions[1].player_name)
    end

end