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
    when 2 then abort('Exit from the game.')
    else @interface.invalid_option
    end
  rescue RuntimeError => e
    @interface.show_error(e.message)
    retry
  end

  def start
    if @player.busted?
      @interface.busted
      p 'GAME OVER'
      exit
    elsif @dealer.busted?
      @interface.dealer_busted(@dealer)
      exit
    else
      @game_running = true
      init_deal
      decision
      @interface.reset_menu(@player)
      @interface.continue? ? flush_and_discard : exit
    end
  end

  def init_deal
    @bank.bet(@player)
    @bank.bet(@dealer)
    2.times do
      @player.take_card(@deck)
      @dealer.take_card(@deck)
    end
    p "Your cards: #{@player.show_cards}"
    p "Dealer's cards: #{@dealer.hide_cards}"
    p "Your score is #{@player.score}"
  rescue RuntimeError => e
    @interface.show_error(e.message)
    abort('Exit from the game.')
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
    end while @game_running == true
  end

  def dealer_decision
    if @dealer.can_take_card?
      @dealer.take_card(@deck)
      p "Dealer took the card: #{@dealer.hide_cards}"
    else
      p 'Dealer made his decision, he wait for your move'
    end
  end

  def add_card
    if @player.can_take_card?
      @player.take_card(@deck)
      p "Your cards:#{@player.show_cards} and score is #{@player.score}"
    else
      @interface.full_hand
    end
  end

  def opening_cards
    puts
    p "Dealer's cards: #{@dealer.show_cards}, score is #{@dealer.score}"
    p "Your cards:#{@player.show_cards}, score is #{@player.score}"
    final_scoring
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
