# frozen_string_literal: true

require_relative './piece'

class Knight < Piece
  TRANSITIONS = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]].freeze

  def update_moves(pieces)
    @moves = []

    TRANSITIONS.each do |transition|
      move = [@coordinates[0] + transition[0], @coordinates[1] + transition[1]]

      get_moves(pieces, move)

      @moves.uniq!
    end
  end

  def get_moves(pieces, move)
    @moves.push(move.dup) unless move.any? { |e| e <= 0 || e > 8 } || move_blocked?(pieces, move)
  end
end
