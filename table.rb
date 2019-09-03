require 'random_data'
require_relative 'player'

class Table
    attr_reader :player_positions

    def initialize(number_of_players, args)
        
        @player_positions = args + Array.new(number_of_players - args.length)
        @player_positions.map! do |name| 
            if name
                Player.new(name)
            else
                Player.new("#{Random.firstname} #{Random.lastname}")
            end
        end    
    end

end