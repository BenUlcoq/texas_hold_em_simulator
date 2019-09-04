# frozen_string_literal: true

require_relative 'poker'

@ARGV = ARGV

@number_of_players = begin
  Integer(@ARGV[0])
                     rescue StandardError
                       10
end

if @ARGV.length > 10 || @number_of_players > 9
  puts 'Please enter an integer value less than 9 for number of players.'
else
  Poker.new(Integer(@ARGV[0]), @ARGV[1..@ARGV.length])
end
