# frozen_string_literal: true

require_relative './pieces/bishop'
require_relative './pieces/king'
require_relative './pieces/knight'
require_relative './pieces/pawn'
require_relative './pieces/queen'
require_relative './pieces/rook'

require_relative './players/human'
require_relative './players/computer'

require 'rainbow'

class Engine
  def initialize
    @counter75 = 0
    @board_history = []
    @board = Board.new
  end

  def create_board(player, enemy, pieces, piece = '')
    # system('clear')

    @board.print_board(pieces, piece)

    puts Rainbow("Warning! #{player.print_color} is in check.").color(:red) if check?(player, enemy)
  end

  def update_player_moves(player, pieces)
    player.pieces.each do |piece|
      piece.update_moves(pieces)
    end
  end

  def filter_moves(player, enemy, pieces)
    temp = Marshal.dump(enemy)

    player.pieces.each do |piece|
      piece.moves.filter! do |move|
        p = filter_moves_helper(player, enemy, pieces, piece, move)

        enemy = Marshal.load(temp)

        p
      end
    end

    enemy = Marshal.load(temp)
  end

  def filter_moves_helper(player, enemy, pieces, piece, move)
    current_coord = piece.coordinates

    update_enemy_pieces(enemy, move, true)

    piece.move_piece(move, true)

    update_player_moves(enemy, pieces)

    good_move = check?(player, enemy)

    piece.move_piece(current_coord, true)

    !good_move
  end

  def check?(player, enemy)
    king = player.pieces.last.coordinates

    enemy.pieces.each { |piece| return true if piece.moves.include?(king) }

    false
  end

  def update_counters(pieces)
    @counter75 += 1

    @board_history.push(Marshal.dump(pieces))
  end

  def update_pieces(player, enemy, piece_to_move, move)
    update_player_pieces(player, piece_to_move, move)

    update_enemy_pieces(enemy, move)
  end

  def update_enemy_pieces(enemy, move, test = false)
    enemy.pieces.each do |piece|
      next unless move == piece.coordinates

      enemy.pieces.delete(piece)

      @counter75 = 0 unless test

      break
    end

    enemy
  end

  def update_player_pieces(player, piece_to_move, move)
    player.pieces.each do |piece|
      next unless piece_to_move == piece

      @counter75 = 0 if piece.instance_of?(Pawn)

      piece.move_piece(move)

      break
    end
  end

  def checkmate?(player, enemy)
    return true if player.pieces.all? { |piece| piece.moves.empty? } && check?(player, enemy)

    false
  end

  def stalemate?(player, enemy)
    return true if player.pieces.all? { |piece| piece.moves.empty? } && !check?(player, enemy)

    false
  end

  def dead_position?(pieces)
    pieces.each do |piece|
      if piece.instance_of?(Rook) || piece.instance_of?(Queen) || (piece.instance_of?(Pawn) && !piece.moves.empty?)
        return false
      end
    end

    dead_position_helper?(pieces)
  end

  def dead_position_helper?(pieces)
    return true if pieces.count { |piece| piece.instance_of?(Bishop) && piece.coordinates.sum.even? } == 2 ||
                   pieces.count { |piece| piece.instance_of?(Bishop) && piece.coordinates.sum.odd? } == 2

    return false if (pieces.count { |piece| piece.instance_of?(Knight) }
                     + pieces.count { |piece| piece.instance_of?(Bishop) }) > 1

    true
  end

  def fivefold_repetition?(pieces)
    counter = 0

    @board_history.each do |board|
      counter += 1 if same_board?(board, pieces)
    end

    return true if counter == 4

    false
  end

  def same_board?(board, pieces)
    Marshal.load(board).each_with_index do |piece, i|
      return false unless piece.moves == pieces[i].moves
    end

    true
  end

  def seventy_five_move_rule?
    return true if @counter75 == 75

    false
  end
end
