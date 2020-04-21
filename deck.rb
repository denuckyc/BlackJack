# frozen_string_literal: true

require_relative './card.rb'

class Deck
  attr_reader :cards

  def initialize
    @cards = []

    Card::SUIT.each_key do |suit|
      Card::VALUES.each_key do |value|
        @cards << Card.new(value, suit)
      end
    end

    @cards.shuffle!
  end
end
