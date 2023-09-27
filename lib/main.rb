# frozen_string_literal: true

require_relative './game'

game = Game.new
game.create_players
p game.play
