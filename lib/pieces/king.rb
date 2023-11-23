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

  def castling(pieces)
    return 0 unless @first_move

    short_castling(pieces)

    long_castling(pieces)
  end

  def get_moves(pieces, move)
    @moves.push(move.dup) unless move.any?(&:zero?) || move.any? { |e| e > 8 } || move_blocked?(pieces, move)
  end

  def short_castling(pieces)
    tiles = [[6, @coordinates[1]], [7, @coordinates[1]]]

    return unless pieces.any? { |piece| piece.coordinates == [8, @coordinates[1]] }

    @moves.push(tiles[1]) if pieces.all? { |piece| short_castle?(piece, tiles) }
  end

  def long_castling(pieces)
    tiles = [[4, @coordinates[1]], [3, @coordinates[1]], [2, @coordinates[1]]]

    return unless pieces.any? { |piece| piece.coordinates == [1, @coordinates[1]] }

    @moves.push(tiles[1]) if pieces.all? { |piece| long_castle?(piece, tiles) }
  end

  private

  def short_castle?(piece, tiles)
    return false if (piece.coordinates == [8, @coordinates[1]] && !piece.first_move) || !castle?(piece, tiles)

    true
  end

  def long_castle?(piece, tiles)
    return false if (piece.coordinates == [1, @coordinates[1]] && !piece.first_move) || !castle?(piece, tiles)

    true
  end

  def castle?(piece, tiles)
    return false if tiles.include?(piece.coordinates) ||
                    (piece.color != @color && piece.moves.any? do |move|
                       move == @coordinates || move == tiles[0] || move == tiles[1]
                     end)

    true
  end
end
