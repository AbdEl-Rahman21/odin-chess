# frozen_string_literal: true

require_relative './board'
require_relative './display'

require_relative './pieces/bishop'
require_relative './pieces/king'
require_relative './pieces/knight'
require_relative './pieces/pawn'
require_relative './pieces/queen'
require_relative './pieces/rook'

require_relative './players/human'
require_relative './players/computer'

class Game
  def initialize
    @players = [Human.new(:w), Human.new(:b)]
    @board = Board.new
    @turn_counter = 0
  end

  def all_pieces
    @players[0].pieces.union(@players[1].pieces)
  end

  def create_board
    @board.print_board(all_pieces)
  end

  def create_players
    system('clear')

    @players.each_with_index do |player, i|
      player.get_name(i + 1)
      player.create_pieces
    end
  end

  def play
    loop do
      turn_order

      break if game_over?

      @turn_counter += 1
    end

    determine_winner
  end

  def turn_order
    @turn_counter.even? ? play_turn(@players[0], @players[1].symbol) : play_turn(@players[1], @players[0].symbol)
  end

  def update_moves(player)
    player.pieces.each { |piece| piece.get_moves(all_pieces) }
  end

  def play_turn(player); end
end

game=Game.new
game.create_players
game.create_board
