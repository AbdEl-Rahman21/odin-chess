# frozen_string_literal: true

require_relative './piece'

class Rook < Piece
  TRANSITIONS = [[-1, 0], [0, -1], [0, 1], [1, 0]].freeze

  def update_moves(pieces)
    @moves = []

    TRANSITIONS.each do |transition|
      move = @coordinates.dup

      get_moves(pieces, move, transition)

      @moves.uniq!
    end
  end

  def get_moves(pieces, move, transition)
    loop do
      move = [move[0] + transition[0], move[1] + transition[1]]

      break if move.any?(&:zero?) || move.any? { |e| e > 8 } || move_blocked?(pieces, move)

      @moves.push(move.dup)
    end
  end
end
