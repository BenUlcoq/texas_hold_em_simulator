# frozen_string_literal: true

# Import Ruby Gem: Random Data
require 'random_data'
require_relative 'deck'
require_relative 'player'
require_relative 'interface'
require 'ruby-poker'

class Poker
  attr_reader :player_positions, :deck, :community_cards, :active_players, :pot_size
  attr_accessor :table_current_bet

  # Passes the player details supplied to the @player_positions array upon initialization.
  def initialize(number_of_players, args)
    @player_positions = args + Array.new(number_of_players - args.length)
    # Loops through the @player_positions array.
    @player_positions.map! do |name|
      # Checks to see whether the current index contains a value.
      if name
        # Creates an instance of the Player class and passes the current iteration's value.
        Player.new(name)
      else
        # Creates an instance of the Player class and passes a randomly generated name value.
        Player.new("#{Random.firstname} #{Random.lastname}")
      end
    end
    @big_blind_value = 50
    @small_blind_value = 25
    @hands_played = 0

    @interface = Interface.new
    @interface.home_screen

    loop do
      @input = STDIN.gets.chomp
      if @input.downcase == 'p' || @input.downcase == 'play'
        play_poker
      elsif @input.downcase == 'r' || @input.downcase == 'rules'
        @interface.poker_rules
      elsif @input.downcase == 'q' || @input.downcase == 'quit'
        system 'exit'
      else
        puts 'Please enter a valid command!'
      end
    end
  end

  # Defines a method containing the flow control for a hand of poker.
  def play_poker
    @pot_size = 0
    @table_current_bet = 0
    @stage_of_play = 0
    @active_players = @player_positions.dup
    init_deck
    deal_hole_cards
    poker_hand
    if @active_players.length != 1
      best_hand
      determine_winner
      payout
    else
      payout
    end
    @player_positions.rotate!
    @hands_played += 1
    play_poker
  end

  def payout
    until @pot_size.zero?
      if @active_players[0].max_winnings < @pot_size && @active_players[0].max_winnings != 0
        puts "#{@active_players[0].player_name} won #{@active_players[0].max_winnings} with high hand: #{@active_players[0].strongest_hand}."
        @active_players[0].chip_stack += @active_players[0].max_winnings
        @pot_size -= @active_players[0].max_winnings
        @active_players[0].max_winnings = 0
        @active_players.shift
      else
        puts "#{@active_players[0].player_name} won #{@pot_size} chips with high hand: #{@active_players[0].strongest_hand}."
        @active_players[0].chip_stack += @pot_size
        @pot_size = 0
        puts "#{@active_players[0].player_name} now has #{@active_players[0].chip_stack} chips."
      end
    end
  end

  def determine_winner
    @active_players.sort! do |player1, player2|
      if player1.strongest_hand > player2.strongest_hand
        -1
      elsif player1.strongest_hand < player2.strongest_hand
        1
      else
        0
      end
    end
  end

  def poker_hand
    if @hands_played == 0
      system 'clear'
      puts "Let's play some poker!"
      sleep(1)
      puts "There are #{@player_positions.length} players at the table."
      sleep(1)
      puts 'Starting stacks are 5000 chips.'
      sleep(1)
      puts 'The small blind is 25 chips and the big blind is 50 chips.'
      sleep(2)
    end

    puts 'Are you ready to play? Enter (Y)es to proceed or (N)o to return to the main menu.'
    loop do
      @input = STDIN.gets.chomp
      if @input.downcase == 'y' || @input.downcase == 'yes'
        break
      elsif @input.downcase == 'n' || @input.downcase == 'no'
        @interface.home_screen
      else
        puts 'Please enter a valid input.'
      end
    end

    @active_players[0].current_bet = @small_blind_value
    @active_players[1].current_bet = @big_blind_value
    @table_current_bet = @active_players[1].current_bet
    @pot_size += @active_players[0].current_bet + @active_players[1].current_bet
    @active_players.rotate!(2)

    while @active_players.length > 1 && @stage_of_play < 4

      puts community_cards.to_s
      if @stage_of_play == 1
        puts 'The flop is now being being dealt.'
        sleep(2)
        deal_flop
      elsif @stage_of_play == 2 && @community_cards.length != 4
        puts 'The turn is now being being dealt.'
        sleep(2)
        deal_post_flop
      elsif @stage_of_play == 3 && @community_cards.length != 5
        deal_post_flop
      end

      loop do
        @active_players.map do |player|
          @active_players.delete(player) if player.folded == true
        end

        if @active_players[0].acted == true && @active_players[0].current_bet == @table_current_bet
          @stage_of_play += 1
          @active_players.map do |player|
            if player.current_bet == @table_current_bet
              player.acted = false unless player.chip_stack.zero?
            end
            player.current_bet = 0
          end
          @table_current_bet = 0
          break

        elsif @active_players[0].acted == true && @active_players[0].chip_stack.zero?
          @active_players[0].rotate!
        else

          @interface.ready_check(@active_players[0])
          loop do
            @input = STDIN.gets.chomp

            if @input.downcase == 'y' || @input.downcase == 'yes'
              @interface.player_info(@active_players[0], @pot_size)
              @interface.current_info(@active_players, @table_current_bet)

              if @stage_of_play.positive?
                puts "The current community cards are #{@community_cards.join(' ')}"
              end

              puts "You have #{@active_players[0].hole_cards.join(' and ')}"
              puts 'What you you like to do?'

              if @active_players[0].acted == true && @active_players[0].current_bet == @table_current_bet
                break

              elsif @active_players[0].current_bet == @table_current_bet
                loop do
                  puts 'You can (C)heck or (R)aise.'
                  @input = STDIN.gets.chomp

                  if @input.downcase == 'c' || @input.downcase == 'check'
                    check_action
                    @active_players.rotate!
                    break

                  elsif @input.downcase == 'r' || @input.downcase == 'raise'
                    raise_bet
                    unless @input_string
                      @active_players.rotate!
                      break
                    end
                  else
                    puts 'Please enter a valid input.'
                  end
                end
                break
              elsif @active_players[0].current_bet < @table_current_bet
                loop do
                  puts 'You can (C)all, (R)aise, or (F)old.'
                  @input = STDIN.gets.chomp

                  if @input.downcase == 'c' || @input.downcase == 'call'
                    call_bet
                    @active_players.rotate!
                    break
                  elsif @input.downcase == 'r' || @input.downcase == 'raise'
                    raise_bet
                    unless @input_string
                      @active_players.rotate!
                      break
                    end
                  elsif @input.downcase == 'f' || @input.downcase == 'fold'
                    fold_hand
                    @active_players.rotate!
                    break
                  else
                    puts 'Please enter a valid input.'
                  end
                end
                break
              end
            else
              puts "That's okay - no rush!"
            end
          end
        end
      end
    end
  end

  # @active_players[0] if @active_players[0].length == 1

  def pot_adjustment
    @pot_size += @active_players[0].current_bet
    @active_players[0].chip_stack -= @active_players[0].current_bet
    @active_players[0].acted = true
  end

  def chip_adjustment
    @table_current_bet = @active_players[0].current_bet
    pot_adjustment
  end

  def fold_hand
    @active_players[0].folded = true
    pot_adjustment
    @active_players[0].current_bet = 0
    system "clear"
    puts 'You have folded your hand.'
    sleep(3)
  end

  def all_in
    loop do
      puts 'You are about to go all in, are you sure? Enter (Y)es to proceed.'
      @input = STDIN.gets.chomp
      if @input.downcase == 'y' || @input.downcase == 'yes'
        @active_players[0].current_bet = @active_players[0].chip_stack
        chip_adjustment
        puts 'You have gone all in! Good Luck!'
        sleep(3)
        break
        # @active_players[0].max_winnings = @pot_size
      else
        puts 'Response not clear enough.'
      end
    end
  end

  def call_bet
    if @active_players[0].chip_stack <= @table_current_bet
      pot_size -= @active_players[0].current_bet
      all_in
    else
      @pot_size -= @active_players[0].current_bet
      @active_players[0].current_bet = @table_current_bet
      chip_adjustment
      system 'clear'
      puts 'You have called the current bet.'
      sleep(3)
    end
  end

  def check_action
    @active_players[0].acted = true
    system 'clear'
    puts 'You have checked.'
    sleep(3)
  end

  def raise_bet
    loop do
      puts 'How much would you like to raise? Or enter (B)ack to change your mind.'

      @input_string = STDIN.gets.chomp
      @input = begin
                 Integer(@input_string)
               rescue StandardError
                 false
               end

      if @input && @input >= @table_current_bet * 2
        if @active_players[0].chip_stack <= @input
          @pot_size -= @active_players[0].current_bet
          all_in
        else
          @pot_size -= @active_players[0].current_bet
          @active_players[0].current_bet = @input
          chip_adjustment
          system "clear"
          puts "You have raised the bet to #{@active_players[0].current_bet} chips."
          sleep(3)
        end
        @input_string = nil
        break
      elsif @input && @input <= @table_current_bet * 2
        puts "Please enter a valid raise amount - your raise must be at least twice the current bet. Current bet is #{@table_current_bet}"
      elsif @input_string.downcase == 'b' || @input_string.downcase == 'back'
        break
      else
        puts 'Please enter a valid, whole number'
      end
    end
    
  end

  def best_hand
    @active_players.map do |player|
      next unless @stage_of_play > 0

      @all_combos = (player.hole_cards + @community_cards).combination(5).to_a
      @best_hand = PokerHand.new
      @current_hand = nil

      @all_combos.map do |hand|
        next unless @all_combos.length > 1

        @current_hand = PokerHand.new(hand)
        if @current_hand > @best_hand
          @best_hand = @current_hand
        else
          @all_combos.delete(hand)
        end
      end

      player.strongest_hand = @best_hand
      puts "#{player.player_name} has #{player.strongest_hand}"
      sleep(1)
    end
  end

  # Defines a method for initializing an instance of the Deck class.
  def init_deck
    @deck = Deck.new
  end

  # Defines a method for dealing cards to each player.
  def deal_hole_cards
    # Initiates a loop, iterating over each player within the active players array.
    @active_players.map do |player|
      # Removes any persistent cards from the player's hands.
      player.hole_cards.clear
    end
    # Initiates a loop that will repeat twice.
    2.times do
      # Initiates a loop, iterating over each player with the active players array.
      @active_players.map do |player|
        # Moves a card from the top of the deckto the current player's hand.
        player.hole_cards.push(@deck.cards.shift)
      end
    end
  end

  # Defines a method for dealing three cards from the top of the deck to the community table cards.
  def deal_flop
    # Burns the top card of the deck.
    @deck.cards.shift
    # Moves the top three cards of the deck into the community table cards array.
    @community_cards = @deck.cards.shift(3)
    "The community cards are now: #{@community_cards.join(', ')}."
  end

  # Defines a method for dealing a single card from the top of the deck to the comunity table cards.
  def deal_post_flop
    # Burns the top card of the deck.
    @deck.cards.shift
    # Moves the top card of the deck into the community table cards array.
    @community_cards.push(@deck.cards.shift)
    "The community cards are now: #{@community_cards.join(', ')}."
  end

  def player_action; end
end
