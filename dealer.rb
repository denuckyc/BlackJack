# frozen_string_literal: true

require_relative './player.rb'

class Dealer < Player
  def initialize(name = 'Dealer')
    super
  end

  def hide_cards
    hide_cards = ''
    @hand.cards.each { hide_cards += '🂠 ' }
    hide_cards
  end

  def can_take_card?
    score < 17 && !full_hand?
  end
end
