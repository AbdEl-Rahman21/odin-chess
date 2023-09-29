# frozen_string_literal: true

require 'rainbow'

require_relative './board'

require_relative './pieces/bishop'
require_relative './pieces/king'
require_relative './pieces/knight'
require_relative './pieces/pawn'
require_relative './pieces/queen'
require_relative './pieces/rook'

require_relative './players/player'

# rubocop:disable Metrics/ClassLength
# Helper class for Game class
class Engine
  def initialize
    @counter75 = 0
    @board_history = []
    @board = Board.new
  end

  def create_board(player, enemy, pieces, piece = '', final: false)
    @board.print_board(pieces, piece)

    # rubocop:disable Layout/LineLength
    puts Rainbow("Warning! #{player.print_color} is in check.").color(:red) if check?(player.pieces.last.coordinates, enemy) && !final
    # rubocop:enable Layout/LineLength
  end

  def update_player_moves(player, pieces)
    player.pieces.each { |piece| piece.update_moves(pieces) }
  end

  def filter_moves(player, enemy_copy, pieces)
    player.pieces.each do |piece|
      piece.jump_move = false if piece.instance_of?(Pawn)

      piece.moves.filter! { |move| filter_moves_helper(player, enemy_copy, pieces, piece, move) }
    end
  end

  def filter_moves_helper(player, enemy_copy, pieces, piece, move)
    current_coord = piece.coordinates

    # rubocop:disable Security/MarshalLoad
    enemy = Marshal.load(enemy_copy)
    # rubocop:enable Security/MarshalLoad

    piece.move_piece(move, test: true)

    update_enemy_pieces(enemy, piece, test: true)

    update_player_moves(enemy, pieces)

    good_move = check?(player.pieces.last.coordinates, enemy)

    piece.move_piece(current_coord, test: true)

    !good_move
  end

  def update_enemy_pieces(enemy, moved_piece, test: false)
    enemy.pieces.each do |piece|
      next unless moved_piece.coordinates == piece.coordinates || en_passant(piece, moved_piece)

      enemy.pieces.delete(piece)

      @counter75 = 0 unless test

      break
    end
  end

  # rubocop:disable Metrics/AbcSize
  def en_passant(piece, moved_piece)
    if piece.instance_of?(Pawn) && piece.jump_move && moved_piece.instance_of?(Pawn)
      if moved_piece.color == :w
        return true if moved_piece.coordinates == [piece.coordinates[0], piece.coordinates[1] + 1]
      elsif moved_piece.coordinates == [piece.coordinates[0], piece.coordinates[1] - 1]
        return true
      end
    end

    false
  end
  # rubocop:enable Metrics/AbcSize

  def check?(player_king, enemy)
    enemy.pieces.each { |piece| return true if piece.moves.include?(player_king) }

    false
  end

  def update_counters(pieces)
    @counter75 += 1

    @board_history.push(Marshal.dump(pieces))
  end

  def update_pieces(player, enemy, piece_to_move, move)
    update_player_pieces(player, piece_to_move, move)

    update_enemy_pieces(enemy, piece_to_move)
  end

  def update_player_pieces(player, piece_to_move, move)
    castle(player, move) if piece_to_move.instance_of?(King) && (piece_to_move.coordinates[0] - move[0]).abs == 2

    player.pieces.each do |piece|
      next unless piece_to_move == piece

      piece.move_piece(move)

      handle_pawn(player, piece) if piece.instance_of?(Pawn)

      break
    end
  end

  def castle(player, move)
    player.pieces.each { |piece| break if piece.instance_of?(Rook) && castle_helper(piece, move) }
  end

  def castle_helper(piece, move)
    if piece.coordinates[0] - move[0] == 1
      piece.move_piece([6, piece.coordinates[1]])
    elsif move[0] - piece.coordinates[0] == 2
      piece.move_piece([4, piece.coordinates[1]])
    else
      return false
    end

    true
  end

  def handle_pawn(player, piece)
    @counter75 = 0

    player.promote(piece) if piece.coordinates[1] == 1 || piece.coordinates[1] == 8
  end

  def checkmate?(player, enemy)
    return true if player.pieces.all? { |piece| piece.moves.empty? } && check?(player.pieces.last.coordinates, enemy)

    false
  end

  def stalemate?(player, enemy)
    return true if player.pieces.all? { |piece| piece.moves.empty? } && !check?(player.pieces.last.coordinates, enemy)

    false
  end

  def dead_position?(pieces)
    pieces.each do |piece|
      # rubocop:disable Layout/LineLength
      return false if piece.instance_of?(Rook) || piece.instance_of?(Queen) || (piece.instance_of?(Pawn) && !piece.moves.empty?)
      # rubocop:enable Layout/LineLength
    end

    dead_position_helper?(pieces)
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/CyclomaticComplexity
  def dead_position_helper?(pieces)
    return true if pieces.count { |piece| piece.instance_of?(Bishop) && piece.coordinates.sum.even? } == 2 ||
                   pieces.count { |piece| piece.instance_of?(Bishop) && piece.coordinates.sum.odd? } == 2

    return false if (pieces.count { |piece| piece.instance_of?(Knight) }
                     + pieces.count { |piece| piece.instance_of?(Bishop) }) > 1

    true
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/CyclomaticComplexity

  def fivefold_repetition?(pieces)
    return true if @board_history.count { |board| same_board?(board, pieces) } == 4

    false
  end

  def same_board?(board, pieces)
    # rubocop:disable Security/MarshalLoad
    Marshal.load(board).each_with_index { |piece, i| return false unless piece.moves == pieces[i].moves }
    # rubocop:enable Security/MarshalLoad

    true
  end

  def seventy_five_move_rule?
    return true if @counter75 == 75

    false
  end
end
# rubocop:enable Metrics/ClassLength
