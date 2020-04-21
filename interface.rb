# frozen_string_literal: true

class Interface
  INVALID_OPTION = 'It is not an option. Try again.'
  FULL_HAND = 'You can\'t\' take more cards.'
  BUSTED = 'Not enough money for a bet.'
  DEALER_BUSTED = 'The casino loses. You win all.'
  GAME_OVER = 'GAME OVER'

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

  def show_results(_player, _dealer, winner = nil)
    if winner.nil?
      puts
      p 'Push!'
      puts
      nil
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

  def dealer_score(dealer)
    p "Dealer's cards: #{dealer.show_cards}, score is #{dealer.score}"
  end

  def player_score(player)
    p "Your cards: #{player.show_cards}, score is #{player.score}"
  end

  def dealer_hide_card(dealer)
    p 'Dealer take a card.'
    p "Dealer's cards: #{dealer.hide_cards}"
  end

  def dealer_dicision
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

  def game_over
    raise GAME_OVER
  end

  def player_with_balance(player)
    p "#{player.name}, you have #{player.balance}$"
    puts
  end

  def exiting
    p 'Exit from the game.'
    exit
  end
end
