# frozen_string_literal: true

class Cards
  attr_reader :value

  SUIT = { spades: '♠', hearts: '♥', diamonds: '♦', clubs: '♣' }.freeze
  VALUES = {
    ace: 'A', two: '2', three: '3', four: '4', five: '5',
    six: '6', seven: '7', eight: '8', nine: '9', ten: '10',
    jack: 'J', queen: 'Q', king: 'K'
  }.freeze
  WEIGHTS = {
    two: 2, three: 3, four: 4, five: 5, six: 6,
    seven: 7, eight: 8, nine: 9, ten: 10,
    jack: 10, queen: 10, king: 10, ace: 1
  }.freeze

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def output
    "#{VALUES[@value]}#{SUIT[@suit]}"
  end

  def ace?
    @value == :ace
  end
end
