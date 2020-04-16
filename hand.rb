# frozen_string_literal: true

class Hand
  attr_reader :cards

  def initialize
    @cards = []
  end

  def take_card(deck)
    card = deck.cards.sample
    @cards << card
    deck.cards.delete(card)
  end

  def score
    points = 0
    aces = 0
    @cards.each do |card|
      aces += 1 if card.ace?
      points += Cards::WEIGHTS[card.value]
    end

    (1..aces).each do
      points += 10 if points + 10 <= 21
    end

    points
  end

  def discard
    @cards = []
  end
end
