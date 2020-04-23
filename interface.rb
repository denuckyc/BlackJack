# frozen_string_literal: true

class Interface
  INVALID_OPTION = 'It is not an option. Try again.'
  FULL_HAND = 'You can\'t\' take more cards.'
  BUSTED = 'Not enough money for a bet.'
  DEALER_BUSTED = 'The casino loses. You win all.'
  GAME_OVER = 'GAME OVER'

  def initialize
    @game = Game.new(Interface.ask_name)
    @game_running = false
  end

  def self.ask_name
    p 'Your name?'
    puts
    gets.chomp.capitalize
  end

  def main_menu
    puts
    p "Welcome to Black Jack, #{@game.player.name}!"
    puts
    player_with_balance
    puts
    p 'Enter \'1\' to play'
    p 'Enter \'2\' to quit'
    puts
    p 'Your choice:'
    run
  end

  def run
    case gets.chomp.to_i
    when 1 then start
    when 2 then exit
    else raise INVALID_OPTION
    end
  rescue RuntimeError => e
    show_error(e.message)
    retry
  end

  def start
    if @game.player.busted?
      raise BUSTED
      raise BUSTED
      exit
    elsif @game.dealer.busted?
      raise DEALER_BUSTED
      exit
    else
      @game_running = true
      round
    end
  end

  def round
    @game.init_deal
    player_score
    dealer_hide_card
    decision
    open_cards
    dealer_score
    player_score
    @game.final_scoring(show_results)
    reset_menu
    continue? ? @game.flush_and_discard && start : exit
  end

  def decision
    begin
      decision_menu
      case gets.chomp.to_i
      when 1 then dealer_decision
      when 2 then add_card
      when 3 then @game_running = false
      else raise INVALID_OPTION
      end
    rescue RuntimeError => e
      show_error(e.message)
      retry
    end while (@game_running == true) && !@game.full_hand_check
  end

  def dealer_decision
    if @game.dealer.can_take_card?
      @game.dealer_add_card
      dealer_hide_card
    else
      dealer_decided
    end
  end

  def add_card
    if @game.player.can_take_card?
      @game.player_add_card
      player_score
    else
      FULL_HAND
    end
  end

  def decision_menu
    puts
    p 'Enter \'1\' to skip turn'
    p 'Enter \'2\' to take another card'
    p 'Enter \'3\' to opening the cards'
    puts
  end

  def show_results
    if @game.define_winner.nil?
      puts
      p 'Push!'
      puts
      nil
    else
      puts
      p "Winner is #{@game.define_winner.name}!"
      puts
    end
  end

  def reset_menu
    player_with_balance
    p 'Do you want to try again?'
    puts
    p 'Enter \'1\' if you want to continue'
    p 'Enter \'2\' if you want to exit'
  end

  def continue?
    case gets.chomp.to_i
    when 1 then true
    when 2 then false
    else raise INVALID_OPTION
    end
  rescue RuntimeError => e
    show_error(e.message)
    retry
  end

  def dealer_score
    p "Dealer's cards: #{@game.dealer.show_cards}, score is #{@game.dealer.score}"
  end

  def player_score
    p "Your cards: #{@game.player.show_cards}, score is #{@game.player.score}"
  end

  def dealer_hide_card
    p 'Dealer take a card.'
    p "Dealer's cards: #{@game.dealer.hide_cards}"
  end

  def dealer_decided
    p 'Dealer made his decision, he wait for your move'
  end

  def open_cards
    p 'Scoring! Lay all cards on the table.'
  end

  def show_error(message)
    puts
    p "Error! #{message}"
    puts
  end

  def dealer_busted
    p "#{@game.dealer.name} have #{@game.dealer.balance}$"
    DEALER_BUSTED
  end

  def player_with_balance
    p "#{@game.player.name}, you have #{@game.player.balance}$"
    puts
  end
end
