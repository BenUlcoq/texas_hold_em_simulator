# frozen_string_literal: true

# require_relative 'poker'
# require_relative 'main'
require 'launchy'
require 'colorize'
require 'tty-spinner'
require 'artii'
# require_relative 'poker'

class Interface
  # Defines a method for launching the homescreen of the application.
  def home_screen
    # system 'clear'
    @artii = Artii::Base.new
    @artii2 = Artii::Base.new font: 'slant'
    puts <<-'EOF'
                                       __
                                 _..-''--'----_.
                               ,''.-''| .---/ _`-._
                             ,' \ \  ;| | ,/ / `-._`-.
                           ,' ,',\ \( | |// /,-._  / /
                           ;.`. `,\ \`| |/ / |   )/ /
                          / /`_`.\_\ \| /_.-.'-''/ /
                         / /_|_:.`. \ |;'`..')  / /
                         `-._`-._`.`.;`.\  ,'  / /
                             `-._`.`/    ,'-._/ /
                               : `-/     \`-.._/
                               |  :      ;._ (
                               :  |      \  ` \
                                \         \   |
                                 :        :   ;
                                 |           /
                                 ;         ,'
                                /         /
                               /         /
                                        /
    EOF
    puts '-----------------------------------------------------------------------------'
    puts @artii.asciify("Texas    Hold    'Em")
    puts @artii2.asciify('      Simulator')
    puts '-----------------------------------------------------------------------------'
    puts "  Weclome to Texas Hold 'Em Simulator! Please select an option to continue."
    puts ''
    puts '                   To start playing poker, enter (P)lay.'
    puts '        To read the rules of poker, enter (R)ules. Opens in browser.'
    puts '                      To quit the app, enter (Q)uit.'
  end

  def poker_rules
    Launchy.open('https://en.wikipedia.org/wiki/Texas_hold_%27em#Rules')
    system 'clear'
    home_screen
  end

  def ready_check(player)
    system 'clear'
    puts "#{player.player_name}, are you ready to act?"
    puts 'Enter (Y)es to continue'
  end

  def player_info(player, pot)
    # system 'clear'
    puts "#{player.player_name}, it is your turn to act."
    puts ''
    puts "You have #{player.chip_stack} chips."
    puts "The total pot size (including current bets) is #{pot} chips."
  end

  def current_info(active_players, table_current_bet)
    if table_current_bet.positive?
      active_players.map do |player|
        if player.current_bet != 0
          print "#{player.player_name} has bet #{player.current_bet} chips. "
        end
      end
      puts ''
      if table_current_bet - active_players[0].current_bet != 0
        puts "It is #{table_current_bet - active_players[0].current_bet} chips to call."
      end
    else
      puts 'There has been no betting yet this round.'
    end
    puts ''

   
  end
end
