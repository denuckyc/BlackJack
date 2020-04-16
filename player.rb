# frozen_string_literal: true

require_relative './hand.rb'

class Player
  attr_reader :name, :balance

  def initialize(name)
    @name = name.to_s
    @balance = 100
    @hand = Hand.new
  end

  def take_card(deck)
    @hand.take_card(deck)
  end

  def show_cards
    all_cards = ''
    @hand.cards.each { |card| all_cards = "#{all_cards} #{card.output}" }
    all_cards.lstrip.gsub(/[♠♥♦♣]/){|s| "#{s} "}
  end

  def discard
    @hand.discard
  end

  def score
    @hand.score
  end

  def busted?
    @balance < 10
  end

  def withdraw(amount = 10)
    @balance -= amount
  end

  def add_money(amount = 10)
    @balance += amount
  end

  def overage?
    score > 21
  end

  def full_hand?
    @hand.cards.length == 3
  end

  def can_take_card?
    !full_hand?
  end
end
