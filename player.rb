# frozen_string_literal: true

class Player
  attr_reader :player_name
  attr_accessor :hole_cards
  def initialize(name)
    @player_name = name
    @hole_cards = []
  end
end
