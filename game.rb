# frozen_string_literal: true

class Game
  attr_reader :player, :dealer, :bank, :deck

  def initialize(player_name)
    @player = Player.new(player_name)
    @dealer = Dealer.new
    @bank = Bank.new
    @deck = Deck.new
  end

  def init_deal
    @bank.bet(@player)
    @bank.bet(@dealer)
    2.times do
      @player.take_card(@deck)
      @dealer.take_card(@deck)
    end
  end

  def full_hand_check
    @player.full_hand? && @dealer.full_hand?
  end

  def dealer_add_card
    @dealer.take_card(@deck)
  end

  def player_add_card
    @player.take_card(@deck)
  end

  def define_winner
    return if @player.overage? && @dealer.overage?
    return if @player.score == @dealer.score
    return @dealer if @player.overage?
    return @player if @dealer.overage?

    [@player, @dealer].max_by(&:score)
  end

  def final_scoring(result)
    if define_winner.nil?
      result
      @bank.push(@player, @dealer)
    else
      result
      @bank.reward(define_winner)
    end
  end

  def flush_and_discard
    @player.discard
    @dealer.discard
    @bank = Bank.new
    @deck = Deck.new
  end
end
