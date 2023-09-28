# frozen_string_literal: true

require_relative './piece'

# Class for the King piece
class King < Piece
  TRANSITIONS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].freeze

  def update_moves(pieces)
    @moves = []

    TRANSITIONS.each do |transition|
      move = [@coordinates[0] + transition[0], @coordinates[1] + transition[1]]

      get_moves(pieces, move)
    end
  end

  def get_moves(pieces, move)
    @moves.push(move.dup) unless move.any?(&:zero?) || move.any? { |e| e > 8 } || move_blocked?(pieces, move)
  end

  def castling(pieces)
    return unless @first_move

    short_castling(pieces)

    long_castling(pieces)
  end

  def short_castling(pieces)
    tiles = [[@coordinates[0] + 1, @coordinates[1]], [@coordinates[0] + 2, @coordinates[1]]]
    castle = true

    pieces.each do |piece|
      next if short_castling_helper(piece, tiles)

      castle = false

      break
    end

    @moves.push(tiles[1]) if castle
  end

  def short_castling_helper(piece, tiles)
    return false if (piece.coordinates == [@coordinates[0] + 3, @coordinates[1]] && !piece.first_move) ||
                    castling_helper(piece, tiles)

    true
  end

  def long_castling(pieces)
    tiles = [[@coordinates[0] - 1, @coordinates[1]], [@coordinates[0] - 2, @coordinates[1]],
             [@coordinates[0] - 3, @coordinates[1]]]
    castle = true

    pieces.each do |piece|
      next if short_castling_helper(piece, tiles)

      castle = false

      break
    end

    @moves.push(tiles[1]) if castle
  end

  def long_castling_helper(piece, _tiles)
    return false if (piece.coordinates == [@coordinates[0] - 4, @coordinates[1]] && !piece.first_move) ||
                    castling_helper(piece, tiles)

    true
  end

  def castling_helper(piece, tiles)
    return true if tiles.include?(piece.coordinates) ||
                   (piece.color != @color && piece.moves.any? do |move|
                      move == @coordinates || move == tiles[0] || move == tiles[1]
                    end)

    false
  end
end
