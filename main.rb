# frozen_string_literal: true

require_relative 'poker'

@argv = ARGV

@number_of_players = begin
  Integer(@argv[0])
                     rescue StandardError
                       10
end



if @argv.length > 10 || @number_of_players > 9
  puts 'Please enter an integer value less than 9 for number of players.'
else
  if @argv.length - 1 > Integer(@argv[0])
    puts "Too many names have been entered, either increase the number of players or remove some names."
  else
    Poker.new(Integer(@argv[0]), @argv[1..@argv.length])
  end
end
