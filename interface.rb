# frozen_string_literal: true

class Interface
  INVALID_OPTION = 'It is not an option. Try again.'.freeze
  FULL_HAND = 'You can\'t\' take more cards.'.freeze
  BUSTED = 'Not enough money for a bet.'.freeze
  DEALER_BUSTED = 'The casino loses.'.freeze

  def self.ask_name
    p 'Your name?'
    puts
    gets.chomp.capitalize
  end

  def main_menu(player)
    puts
    p "Welcome to Black Jack, #{player.name}!"
    puts
    player_with_balance(player)
    puts
    p 'Enter \'1\' to play'
    p 'Enter \'2\' to quit'
    puts
  end

  def choice
    puts
    p 'Your choice:'
    gets.chomp.to_i
  end

  def decision_menu
    puts
    p 'Enter \'1\' to skip turn'
    p 'Enter \'2\' to take another card'
    p 'Enter \'3\' to opening the cards'
    puts
  end

  def show_results(player, dealer, winner = nil)
    if winner.nil?
      puts
      p 'Push!'
      puts
      return
    else
      puts
      p "Winner is #{winner.name}!"
      puts
    end
  end

  def reset_menu(player)
    player_with_balance(player)
    p 'Do you want to try again?'
    puts
    p 'Enter \'1\' if you want to continue'
    p 'Enter \'2\' if you want to exit'
  end

  def continue?
    case choice
    when 1 then true
    when 2 then false
    else invalid_choice
    end
  end

  def show_error(message)
    puts
    p "Error! #{message}"
    puts
  end

  def full_hand
    raise FULL_HAND
  end

  def busted
    raise BUSTED
  end

  def dealer_busted(dealer)
    p "#{dealer.name} have #{dealer.balance}$"
    DEALER_BUSTED
  end

  def invalid_option
    raise INVALID_OPTION
  end

  def player_with_balance(player)
    p "#{player.name}, you have #{player.balance}$"
    puts
  end
end
