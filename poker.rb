# frozen_string_literal: true

require_relative 'table'

class Poker
    attr_reader :table
    
    def initialize(number_of_players, *args)
        @table = Table.new(number_of_players, args)
        home_screen
    end

    def home_screen
        puts "Welcome to Texas Hold 'Em Simulator!"

        if gets.chomp == "play"
            play_poker
        end
    end

    def init_deck
        @ranks = [*(2..9), "T", "J", "Q", "K", "A"]
        @suits = ["C", "H", "S", "D"]

        @ranks.each do |rank|
            @suits.each do |suit|
              @table.deck << ("#{rank}#{suit}")
            end
          end

        # @table.deck.shuffle!

    end

    def deal_cards
        p @table.deck
        @table.player_positions.map do |player|
            player.hole_cards.clear
        end

        2.times do
            @table.player_positions.map do |player|
                player.hole_cards.push(@table.deck[0])
                @table.deck.shift
            end
        end
    end

    def play_poker
        init_deck
        deal_cards
    end


end
