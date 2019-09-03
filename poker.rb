# frozen_string_literal: true

require_relative 'table'

class Poker
    attr_reader :table

    def initialize(number_of_players, *args)
        @table = Table.new(number_of_players, args)
    end

    def self.home_screen
        puts "Welcome to Texas Hold 'Em Simulator!"
    end

    home_screen

end
