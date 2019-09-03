# frozen_string_literal: true

require 'random_data'

class Poker
  attr_accessor :player_positions, :args

  def initialize(number_of_players, *args)
    @player_positions = args + Array.new(number_of_players - args.length)
    @player_positions.map! { |names| names || "#{Random.firstname} #{Random.lastname}" }
  end
end
