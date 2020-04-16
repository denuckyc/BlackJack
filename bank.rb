# frozen_string_literal: true

class Bank
  attr_reader :bank

  def initialize
    @bank = 0
  end

  def bet(player, bet = 10)
    player.withdraw(bet)
    @bank += bet
  end

  def reward(player)
    player.add_money(@bank)
    @bank = 0
  end

  def push(player, dealer)
    player.add_money(@bank / 2)
    dealer.add_money(@bank / 2)
    @bank = 0
  end
end
