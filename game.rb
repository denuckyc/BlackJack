# frozen_string_literal: true

require_relative './player.rb'
require_relative './dealer.rb'
require_relative './deck.rb'
require_relative './interface.rb'
require_relative './bank.rb'

class Game
  def initialize(player_name)
    @game_running = false
    @player = Player.new(player_name)
    @dealer = Dealer.new
    @bank = Bank.new
    @deck = Deck.new
    @interface = Interface.new
    run
  end

  def run
    @interface.main_menu(@player)
    case @interface.choice
    when 1 then start
    when 2 then @interface.exiting
    else @interface.invalid_option
    end
  rescue RuntimeError => e
    @interface.show_error(e.message)
    retry
  end

  def start
    if @player.busted?
      @interface.busted
      @interface.game_over
      @interface.exiting
    elsif @dealer.busted?
      @interface.dealer_busted(@dealer)
      @interface.exiting
    else
      @game_running = true
      round
    end
  end

  def init_deal
    @bank.bet(@player)
    @bank.bet(@dealer)
    2.times do
      @player.take_card(@deck)
      @dealer.take_card(@deck)
    end
    @interface.player_score(@player)
    @interface.dealer_hide_card(@dealer)
  rescue RuntimeError => e
    @interface.show_error(e.message)
    @interface.exiting
  end

  def round
    init_deal
    decision
    @interface.open_cards
    @interface.dealer_score(@dealer)
    @interface.player_score(@player)
    final_scoring
    @interface.reset_menu(@player)
    @interface.continue? ? flush_and_discard : @interface.exiting
  end

  def decision
    begin
      @interface.decision_menu
      decision_menu = gets.chomp.to_i
      case decision_menu
      when 1 then dealer_decision
      when 2 then add_card
      when 3 then opening_cards
      else @interface.invalid_option
      end
    rescue RuntimeError => e
      @interface.show_error(e.message)
      retry
    end while (@game_running == true) && (full_hand_check == false)
  end

  def full_hand_check
    @player.full_hand? && @dealer.full_hand?
  end

  def dealer_decision
    if @dealer.can_take_card?
      @dealer.take_card(@deck)
      @interface.dealer_hide_card(@dealer)
    else
      @interface.dealer_dicision
    end
  end

  def add_card
    if @player.can_take_card?
      @player.take_card(@deck)
      @interface.player_score(@player)
    else
      @interface.full_hand
    end
  end

  def opening_cards
    @game_running = false
  end

  def define_winner
    return if @player.overage? && @dealer.overage?
    return if @player.score == @dealer.score
    return @dealer if @player.overage?
    return @player if @dealer.overage?

    [@player, @dealer].max_by(&:score)
  end

  def final_scoring
    winner = define_winner
    if winner.nil?
      @interface.show_results(@player, @dealer)
      @bank.push(@player, @dealer)
    else
      @interface.show_results(@player, @dealer, winner)
      @bank.reward(winner)
    end
  end

  def flush_and_discard
    @player.discard
    @dealer.discard
    @bank = Bank.new
    @deck = Deck.new
    start
  end
end
