# frozen_string_literal: true

require_relative './cards.rb'

class Deck
  attr_reader :cards

  def initialize
    @cards = []

    Cards::SUIT.each_key do |suit|
      Cards::VALUES.each_key do |value|
        @cards << Cards.new(value, suit)
      end
    end

    @cards.shuffle!
  end
end
