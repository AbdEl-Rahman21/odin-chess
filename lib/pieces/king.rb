# frozen_string_literal: true

require_relative './piece'

class King < Piece
  TRANSITIONS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].freeze

  def update_moves(pieces)
    @moves = []

    TRANSITIONS.each do |transition|
      move = [@coordinates[0] + transition[0], @coordinates[1] + transition[1]]

      get_moves(pieces, move)

      @moves.uniq!
    end
  end

  def get_moves(pieces, move)
    @moves.push(move.dup) unless move.any?(&:zero?) || move.any? { |e| e > 8 } || move_blocked?(pieces, move)
  end
end
