# frozen_string_literal: true

# require_relative 'poker'
# require_relative 'main'
require 'launchy'
require 'colorize'
require 'artii'
# require_relative 'poker'

class Interface
  # Defines a method for launching the homescreen of the application.
  def home_screen
    # system 'clear'
    @artii = Artii::Base.new
    @artii2 = Artii::Base.new font: 'slant'
    
    @ascii_home = <<-'EOF'
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
    puts @ascii_home
    puts '-----------------------------------------------------------------------------'.light_red
    puts @artii.asciify("Texas    Hold    'Em").light_red
    puts @artii2.asciify('      Simulator').light_yellow
    puts '-----------------------------------------------------------------------------'.light_red
    puts "  Welcome to Texas Hold 'Em Simulator! Please select an option to continue."
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
    puts "#{player.player_name},".light_green + " are you ready to act?"
    puts "Enter " + "(Y)es".light_green + " to continue"
  end

  def player_info(player, pot)
    system 'clear'
    puts "#{player.player_name},".light_green + " it is your turn to act."
    puts ''
    puts "You have " + "#{player.chip_stack}".light_green + " chips."
    puts "The total pot size (including current bets) is " + "#{pot}".light_red + " chips."
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
        puts ""
        puts "It is " + "#{table_current_bet - active_players[0].current_bet}".light_red + " chips to call."
      end
    else
      puts 'There has been no betting yet this round.'
    end
    puts ''
  end

  def welcome_message(positions)
    system 'clear'
    puts "Let's play some poker!".light_red
    sleep(1)
    puts "There are " + "#{positions.length}".yellow + " players at the table."
    sleep(1)
    puts "Starting stacks are " + "5000 chips.".light_green
    sleep(1)
    puts "The " + "small blind is 25 chips".light_yellow + " and the " + "big blind is 50 chips.".light_red
    puts ''
    sleep(2)
  end

  def card_output(cards)

    cards.each do |card|

      case true
      when card.downcase.include?("h") 
        print " #{card.chars[0]} of Hearts ".light_red.on_light_white
        # print "#{card}".light_red.on_light_white
      when card.downcase.include?("c")
        print " #{card.chars[0]} of Clubs ".black.on_light_white
        # print "#{card}".black.on_light_white
      when card.downcase.include?("d")
        print " #{card.chars[0]} of Diamonds ".red.on_light_white
        # print "#{card}".red.on_light_white
      when card.downcase.include?("s")
        print " #{card.chars[0]} of Spades ".light_black.on_light_white
        # print "#{card}".light_black.on_light_white
      else
      end
      print " and the " unless card == cards.last
    end
  end

end
