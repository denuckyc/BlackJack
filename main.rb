# frozen_string_literal: true

require_relative './interface.rb'
require_relative './game.rb'

Game.new(Interface.ask_name)
