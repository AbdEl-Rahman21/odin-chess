# frozen_string_literal: true

require_relative './board'
require_relative './display'

require_relative '../pieces/bishop'
require_relative '../pieces/king'
require_relative '../pieces/knight'
require_relative '../pieces/pawn'
require_relative '../pieces/queen'
require_relative '../pieces/rook'

require_relative '../players/human'
require_relative '../players/computer'

class Game
  def initialize
    @players = []
    @game_state = :n        # :n = normal, :c = check, :cm = checkmate
    @board = Board.new
  end

  def print
    @board.print_board(@white_pieces.union(@black_pieces))
  end
end

Game.new.print
