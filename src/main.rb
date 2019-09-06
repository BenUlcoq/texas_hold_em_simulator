# frozen_string_literal: true

require_relative 'poker'

# Stores the arguments passed via the CLI.
@argv = ARGV

# Checks to see if an integer has been passed correctly. If it hasn't, sets it to an illegal value (10)
@number_of_players = begin
  Integer(@argv[0])
                     rescue StandardError
                       10
end
# If the player has entered incorrect data then an error is outputted.
# Otherwise, creates an instance of the Poker class.
if @argv.length > 10 || @number_of_players > 9
  puts 'Please enter an integer value less than 9 for number of players.'
elsif @argv.length - 1 > Integer(@argv[0])
  puts 'Too many names have been entered, either increase the number of players or remove some names.'
else
  Poker.new(Integer(@argv[0]), @argv[1..@argv.length])
end
